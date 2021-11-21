# Catboost

```bash
# https://github.com/catboost/catboost/releases/tag/v1.0.3

catboost fit --learn-set train.tsv --cv "Classical:0;5" --column-description train_description.txt --custom-loss="Precision,Recall" --logging-level Verbose --loss-function MultiClass --has-header --task-type GPU --od-pval 0.01

# Probability of each class
catboost calc -m model.bin --column-description test_description.txt -T 4 --output-columns "LogProbability,Class,BONE" --input-path test.tsv  --output-path output.tsv --has-header
```

Open in libreoffice calc. Create a pivot table. Add Bone and the Class to the row fields and hide the VRM_BONE_NONE class.

Todo: start probabilities from the root bone outwards
