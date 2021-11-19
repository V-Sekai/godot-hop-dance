https://github.com/catboost/catboost/releases/tag/v1.0.3

catboost fit --learn-set train.tsv --test-set test.tsv --column-description cd.txt --custom-loss="Precision,Recall" --logging-level Verbose --loss-function MultiClassOneVsAll --text-processing processing.json --learning-rate 0.03 --task-type GPU

catboost calc -m model.bin --input-path test.tsv --has-header --column-description cd.txt -o custom_data.eval -T 4 --output-columns Class,#42:Bone\ Name
