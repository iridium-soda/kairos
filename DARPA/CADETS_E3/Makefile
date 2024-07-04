prepare:
	mkdir -p ./artifact/

create_database:
	time1=$(date "+%Y-%m-%d %H:%M")
	echo create_database start:$time1
	python create_database.py
	time2=$(date "+%Y-%m-%d %H:%M")
	echo create_database ends:$time2
	timestamp1=$(date -d "$time1" +%s)
	timestamp2=$(date -d "$time2" +%s)
	diff=$((timestamp2 - timestamp1))
	diff_minutes=$((diff / 60))
	echo "create_database time difference: $diff_minutes mins"
	echo "============================================"

embed_graphs:
	time1=$(date "+%Y-%m-%d %H:%M")
	echo embedding start:$time1
	python embedding.py
	time2=$(date "+%Y-%m-%d %H:%M")
	echo embedding ends:$time2
	timestamp1=$(date -d "$time1" +%s)
	timestamp2=$(date -d "$time2" +%s)
	diff=$((timestamp2 - timestamp1))
	diff_minutes=$((diff / 60))
	echo "embedding time difference: $diff_minutes mins"
	echo "============================================"

train:
	time1=$(date "+%Y-%m-%d %H:%M")
	echo train start:$time1
	python train.py
	time2=$(date "+%Y-%m-%d %H:%M")
	echo train ends:$time2
	timestamp1=$(date -d "$time1" +%s)
	timestamp2=$(date -d "$time2" +%s)
	diff=$((timestamp2 - timestamp1))
	diff_minutes=$((diff / 60))
	echo "train time difference: $diff_minutes mins"
	echo "============================================"

test:
	time1=$(date "+%Y-%m-%d %H:%M")
	echo test start:$time1
	python test.py
	time2=$(date "+%Y-%m-%d %H:%M")
	echo test ends:$time2
	timestamp1=$(date -d "$time1" +%s)
	timestamp2=$(date -d "$time2" +%s)
	diff=$((timestamp2 - timestamp1))
	diff_minutes=$((diff / 60))
	echo "test time difference: $diff_minutes mins"
	echo "============================================"

anomalous_queue:
	time1=$(date "+%Y-%m-%d %H:%M")
	echo anomalous_queue_construction start:$time1
	python anomalous_queue_construction.py
	time2=$(date "+%Y-%m-%d %H:%M")
	echo anomalous_queue_construction ends:$time2
	timestamp1=$(date -d "$time1" +%s)
	timestamp2=$(date -d "$time2" +%s)
	diff=$((timestamp2 - timestamp1))
	diff_minutes=$((diff / 60))
	echo "anomalous_queue_construction time difference: $diff_minutes mins"
	echo "============================================"
evaluation:
	time1=$(date "+%Y-%m-%d %H:%M")
	echo evaluation start:$time1
	python evaluation.py
	time2=$(date "+%Y-%m-%d %H:%M")
	echo evaluation ends:$time2
	timestamp1=$(date -d "$time1" +%s)
	timestamp2=$(date -d "$time2" +%s)
	diff=$((timestamp2 - timestamp1))
	diff_minutes=$((diff / 60))
	echo "evaluation time difference: $diff_minutes mins"
	echo "============================================"

attack_investigation:
	time1=$(date "+%Y-%m-%d %H:%M")
	echo attack_investigation start:$time1
	python attack_investigation.py
	time2=$(date "+%Y-%m-%d %H:%M")
	echo attack_investigation ends:$time2
	timestamp1=$(date -d "$time1" +%s)
	timestamp2=$(date -d "$time2" +%s)
	diff=$((timestamp2 - timestamp1))
	diff_minutes=$((diff / 60))
	echo "attack_investigation time difference: $diff_minutes mins"
	echo "============================================"

clean:
	echo "============================================"
	time1=$(date "+%Y-%m-%d %H:%M")
	echo Clean start:$time1
	bash ./scripts/clean.sh
	time2=$(date "+%Y-%m-%d %H:%M")
	echo Clean ends:$time2
	timestamp1=$(date -d "$time1" +%s)
	timestamp2=$(date -d "$time2" +%s)
	diff=$((timestamp2 - timestamp1))
	diff_minutes=$((diff / 60))
	echo "Cleanup time difference: $diff_minutes mins"
	echo "============================================"

preprocess: prepare create_database embed_graphs

deep_graph_learning: train test

anomaly_detection: anomalous_queue evaluation

pipeline: clean preprocess deep_graph_learning anomaly_detection attack_investigation

pretrained: clean preprocess test anomaly_detection