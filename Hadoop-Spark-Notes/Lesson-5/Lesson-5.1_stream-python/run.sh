hadoop jar /usr/lib/hadoop/contrib/streaming/hadoop-streaming-1.1.2.21.jar  -file ./mapper.py -mapper ./mapper.py  -file ./reducer.py -reducer ./reducer.py  -input /user/doug/war-and-peace/war-and-peace.txt -output /user/doug/war-and-peace-output

