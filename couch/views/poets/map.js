function(doc) {
    // !code lib/poem_check.js

    if (doc.type == 'poem' && sane_poem(doc)) {
        emit(doc.author, doc.title);
    }
}