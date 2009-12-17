function sane_poem(doc) {
    var author = doc.author;
    
    // is not "", "Anonymous", or contain any quote characters
    return author.length > 0 && author != "Anonymous" && author.indexOf('"') == -1 && author.indexOf("(") == -1;
}