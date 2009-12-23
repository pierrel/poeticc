function(doc) {
    if (doc.type == 'poem') {
        emit(doc.source, 1);
    }
}