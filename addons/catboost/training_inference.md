# Catboost

```bash
# https://github.com/catboost/catboost/releases/tag/v1.0.3

catboost fit --learn-set train.tsv --cv "Classical:0;5" --column-description train_description.txt --custom-loss="Precision,Recall" --logging-level Verbose --loss-function MultiClass --has-header --task-type GPU --od-pval 0.01

# Probability of each class
catboost calc -m model.bin --column-description test_description.txt -T 4 --output-columns "Class,BONE,Probability" --input-path test.tsv  --output-path output.tsv --has-header
```

Open in libreoffice calc and sort by class desc, uncertain #1, uncertain #2, bone name, vrm bone name

Todo: start probabilities from the root bone outwards
