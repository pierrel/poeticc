function(doc) {
    // !code lib/poem_check.js

    if (doc.type == 'poem' && sane_poem(doc)) {
	var split_name = doc.author.split(' ');
	var last_name = split_name.pop();
        emit(last_name + ", " + split_name.join(' '), doc.title); // looks like key: 'last, first', 
	                                                          //            value: 'work name'
    }
}