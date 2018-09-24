hadoop pipes -D hadoop.pipes.java.recordreader=true   -D hadoop.pipes.java.recordwriter=true -input war-and-peace   -output war-and-peace-out  -program bin/wordcount
