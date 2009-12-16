function(doc) {
    if (doc.type == 'poem') {
        emit([doc.author, doc.title], 1);
    }
}