https://github.com/catboost/catboost/releases/tag/v1.0.3

catboost fit --learn-set train.tsv --test-set test.tsv --column-description cd.txt --custom-loss="AUC,Precision,Recall" --logging-level Verbose --loss-function Logloss --text-processing processing.json 

catboost calc -m model.bin --column-description cd.txt -o custom_data.eval -T 4 --output-columns TotalUncertainty,#29:VRM\ Bone,#27:Bone,Class --input-path test.tsv  --output-path output.tsv

Open in openoffice calc and sort by class desc, uncertain #1, uncertain #2, vrm bone name, bone name
