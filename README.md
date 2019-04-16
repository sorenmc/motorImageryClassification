# motorImageryClassification
Machine learning on motor imagery data.

[Motor imagery][1] is the task of imagining the movement of a limb. This will produce signals from the brain to the limb that are very similar to the signals that the actual movement of the limb would produce. There are multiple ways to sample these signals, but the most common way is to place Ag/AgCl electrodes on the scalp in the international [10-20 system][2]. In this project this was turned into a classification problem.
To develop and test algorithms we used [dataset 2a from BCI competition IV][3]. 

The main files for data set 2a are 

dataSet2AOVO.m
dataSet2AOVR.m
dataSet2aDeepAll.m
mainDataset2A.m

The first 2 utilize Filter Bank Common Spatial Patterns (FBCSP) with the one versus one (OVO) and the one versus rest (OVR) multi class extension. dataSet2aDeepAll.m trains a deep convolutional neural network.


[1]: https://en.wikipedia.org/wiki/Motor_imagery
[2]: https://en.wikipedia.org/wiki/10%E2%80%9320_system_(EEG)
[3]: https://github.com/bregydoc/bcidatasetIV2a
