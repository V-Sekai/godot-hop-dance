# Catboost

```bash
# https://github.com/catboost/catboost/releases/tag/v1.0.3

catboost fit --learn-set train.tsv --cv "Classical:0;5" --column-description train_description.txt --custom-loss="Precision,Recall" --logging-level Verbose --loss-function MultiClass --has-header --task-type GPU --od-pval 0.01

Can play with `--rsm 0.01`.

# Probability of each class
catboost calc -m model.bin --column-description test_description.txt -T 4 --output-columns "LogProbability,Class,BONE" --input-path test.tsv  --output-path output.tsv --has-header
```

Open in libreoffice calc. Create a pivot table. Add Bone and the Class to the row fields and hide the VRM_BONE_NONE class.

Todo: start probabilities from the root bone outwards

## License 

MIT License

Copyright (c) 2020 K. S. Ernest (iFire) Lee & V-Sekai

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
