import 'package:flutter/material.dart';

import 'models/stock_note.dart';

void main() {
  runApp(const UScreenerNotesApp());
}

class UScreenerNotesApp extends StatelessWidget {
  const UScreenerNotesApp({super.key, this.nowProvider = DateTime.now});

  final DateTime Function() nowProvider;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'US Screener Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: NotesHomeScreen(nowProvider: nowProvider),
    );
  }
}

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key, this.nowProvider = DateTime.now});

  final DateTime Function() nowProvider;

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  late final List<StockNote> _notes;
  int _nextLocalId = 0;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _notes = _sampleNotes(widget.nowProvider());
    _nextLocalId = _notes.length;
  }

  List<StockNote> get _filteredNotes {
    final normalizedQuery = _query.trim().toLowerCase();
    final source = [..._notes]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    if (normalizedQuery.isEmpty) {
      return source;
    }

    return source.where((note) {
      final searchable = [note.title, note.ticker, note.content].join(' ').toLowerCase();
      return searchable.contains(normalizedQuery);
    }).toList();
  }

  Future<void> _createNote() async {
    final result = await Navigator.of(context).push<_EditorResult>(
      MaterialPageRoute(
        builder: (_) => const NoteEditorScreen(),
      ),
    );

    if (!mounted || result == null || result.action != _EditorAction.save) {
      return;
    }

    setState(() {
      final now = widget.nowProvider();
      _notes.add(
        StockNote(
          id: 'local-${now.microsecondsSinceEpoch}-${_nextLocalId++}',
          title: result.title,
          ticker: result.ticker,
          content: result.content,
          updatedAt: now,
        ),
      );
    });
  }

  Future<void> _editNote(StockNote note) async {
    final result = await Navigator.of(context).push<_EditorResult>(
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(note: note),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      if (result.action == _EditorAction.delete) {
        _notes.removeWhere((item) => item.id == note.id);
        return;
      }

      if (result.action == _EditorAction.save) {
        final index = _notes.indexWhere((item) => item.id == note.id);
        if (index != -1) {
          _notes[index] = note.copyWith(
            title: result.title,
            ticker: result.ticker,
            content: result.content,
            updatedAt: widget.nowProvider(),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('US Screener Notes'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                key: const Key('searchField'),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Search notes',
                  hintText: 'Title, ticker, or analysis text',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyState(hasQuery: _query.trim().isNotEmpty)
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final note = filtered[index];
                          return Card(
                            child: ListTile(
                              onTap: () => _editNote(note),
                              title: Text(note.title.isEmpty ? 'Untitled note' : note.title),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (note.ticker.isNotEmpty)
                                      Text(
                                        note.ticker,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    const SizedBox(height: 2),
                                    Text(
                                      note.content.isEmpty ? 'No analysis yet.' : note.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Updated ${_formatDateTime(note.updatedAt)}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNote,
        icon: const Icon(Icons.add),
        label: const Text('New note'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sticky_note_2_outlined, size: 56),
          const SizedBox(height: 8),
          Text(
            hasQuery ? 'No matching notes found' : 'No notes yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            hasQuery
                ? 'Try another keyword for title, ticker, or content.'
                : 'Tap New note to start your US stock analysis.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note});

  final StockNote? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _tickerController;
  late final TextEditingController _contentController;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _tickerController = TextEditingController(text: widget.note?.ticker ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tickerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final ticker = _tickerController.text.trim().toUpperCase();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title or note content is required.')),
      );
      return;
    }

    Navigator.of(context).pop(
      _EditorResult(
        action: _EditorAction.save,
        title: title,
        ticker: ticker,
        content: content,
      ),
    );
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This note will be removed from local app state.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop(
        const _EditorResult(
          action: _EditorAction.delete,
          title: '',
          ticker: '',
          content: '',
        ),
      );
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit note' : 'New note'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                key: const Key('titleField'),
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('tickerField'),
                controller: _tickerController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'US ticker (e.g. AAPL)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  key: const Key('contentField'),
                  controller: _contentController,
                  textCapitalization: TextCapitalization.sentences,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Analysis notes',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _isEditing
                        ? OutlinedButton.icon(
                            onPressed: _delete,
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Delete'),
                          )
                        : OutlinedButton.icon(
                            onPressed: _cancel,
                            icon: const Icon(Icons.close),
                            label: const Text('Cancel'),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorResult {
  const _EditorResult({
    required this.action,
    required this.title,
    required this.ticker,
    required this.content,
  });

  final _EditorAction action;
  final String title;
  final String ticker;
  final String content;
}

enum _EditorAction { save, delete }

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$month/$day ${hour}:$minute';
}

List<StockNote> _sampleNotes(DateTime now) {
  return [
    StockNote(
      id: 'aapl',
      title: 'AAPL pullback watch',
      ticker: 'AAPL',
      content: 'Monitor support around 20-day MA and watch iPhone demand signals.',
      updatedAt: now.subtract(const Duration(hours: 2)),
    ),
    StockNote(
      id: 'nvda',
      title: 'NVDA earnings setup',
      ticker: 'NVDA',
      content: 'Track data center guidance and margin commentary before adding size.',
      updatedAt: now.subtract(const Duration(hours: 5)),
    ),
    StockNote(
      id: 'msft',
      title: 'MSFT cloud momentum',
      ticker: 'MSFT',
      content: 'Validate Azure growth trend and AI monetization updates from management.',
      updatedAt: now.subtract(const Duration(days: 1)),
    ),
  ];
}
