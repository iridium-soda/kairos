prepare:
	mkdir -p ./artifact/

create_database:
	bash ./scripts/create_database.sh

embed_graphs:
	bash ./scripts/embed_graphs.sh

train:
	bash ./scripts/train.sh

test:
	bash ./scripts/test.sh

anomalous_queue:
	bash ./scripts/anomalous_queue.sh

evaluation:
	bash ./scripts/evaluation.sh

attack_investigation:
	bash ./scripts/attack_investigation.sh

clean:
	bash ./scripts/clean.sh

preprocess: prepare create_database embed_graphs

deep_graph_learning: train test

anomaly_detection: anomalous_queue evaluation

pipeline: clean preprocess deep_graph_learning anomaly_detection attack_investigation

pretrained: clean preprocess test anomaly_detection
