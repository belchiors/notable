import 'package:flutter/cupertino.dart';
import 'package:notable/data/repository.dart';
import 'package:notable/model/note_model.dart';

class NotesProvider extends ChangeNotifier {
  Repository? _repository = Repository();
  List<Note>? _notes;
  List<Note>? _archived;
  List<Note>? _deleted;

  Future<List<Note>?> get notes async {
    _notes = await _repository?.getAll();
    return _notes;
  }

  Future<List<Note>?> get archived async {
    _archived = await _repository?.getAllArchived();
    return _archived;
  }

  Future<List<Note>?> get deleted async {
    _deleted = await _repository?.getAllDeleted();
    return _deleted;
  }

  Future<void> addNew(Note note) async {
    if (note.id != null) {
      await _repository?.update(note);
    } else {
      await _repository?.insert(note);
    }
    notifyListeners();
  }

  Future<void> moveToTrash(Set<int> items) async {
    for (int id in items) {
      await _repository?.softDelete(id);
    }
    notifyListeners();
  }

  Future<void> restore(Set<int> items) async {
    for (int id in items) {
      await _repository?.restore(id);
    }
    notifyListeners();
  }

  Future<void> archive(Set<int> items) async {
    for (int id in items) {
      await _repository?.archive(id);
    }
    notifyListeners();
  }

  Future<void> unarchive(Set<int> items) async {
    for (int id in items) {
      await _repository?.unarchive(id);
    }
    notifyListeners();
  }

  Future<void> deletePermanently(Set<int> items) async {
    for (int id in items) {
      await _repository?.deletePermanently(id);
    }
    notifyListeners();
  }

  Future<void> emptyTrash() async {
    for (var item in _deleted!) {
      await _repository?.deletePermanently(item.id!);
    }
    notifyListeners();
  }

  Future<void> deleteOldItems() async {
    await _repository?.emptyTrash();
    notifyListeners();
  }
}
