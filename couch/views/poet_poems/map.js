function(doc) {
    // !code lib/poem_check.js

    if (doc.type == 'poem') {
        emit([doc.author, doc.title], 1);
    }
}