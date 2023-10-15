# Introduction

The goal of this homework assignment is to assess your ability to deal with real data used at CrowdSec, your approach to the problem, and the basic concepts in data science (EDA, visualization, model training, ... ).

Ar first, you might want to take a look at the [official documentation](https://doc.crowdsec.net/docs/intro) of the CrowdSec software. This will remind you of the context of how the data are collected, as well as the purpose of the software. 

We favor the explanations and the details of your approach over the performance of the model picked up. The quality of the code is not a priority, but you should do your best to stick to Python conventions and keep the code clear. You may use *any* library you want, just list them in a `requirements.txt` file attached. The results of the homework assignment should be in the form of a Jupyter notebook - don't hesitate to use Markdown cells to explain your approach. 

# Data Description

The data are split into 3 datasets: `malicious_ips.csv`, `watchers.csv` and `autonomous_systems.csv`

## Malicious IPs

The first dataset `malicious_ips.csv` is the most important one, as it contains a set of malicious IPs that were reported by the watchers (*aka* the CrowdSec Instance) for a particular type of attack
The data is an extract of our database taken during a short time period (Hence we omit the time dimension in the assignment)

`malicious IPs.csv` :
* id: the unique identifier of the malicious IP
* attack_type, str: one of ['Bruteforce', 'Crawler', 'Exploit', 'Other', 'Scanner', 'Spammer']. This is the high-level category of an attack. Here we assume for simplicity that one malicious IP performs only one type of attack.
* watcher_reported, list[int]: the ID of the watchers which reported the attack. 
* is_validated, bool: True if the malicious IP was redistributed to the community as malicious, False if not. A blank value means that the label is missing: the goal is to infer it in section 3.
* as_num (Autonomous System Number): This is the number of the [Autonomous System](https://en.wikipedia.org/wiki/Autonomous_system_(Internet)), which can be seen as the organization to which the IP belongs. 
* country: The country attached to the IP address

## Watchers
`watchers.csv` contains general information about the CrowdSec Software which reported the malicious IPs in the first dataset.
* id: the unique identifier of the watcher. 
* age_in_days: the number of days between the first time and the last time a watcher was active
* activity_in_days: The number of days a watcher reported data between the first time and the last time it was seen. It is less or equal than the age_in_days
* n_ips_reported: The number of malicious IPs that were reported by this watcher over its lifetime. This is a proof of commitment in the network. 
* hp_overlap_rate, float in [0, 1]: The share of `n_ips_reported` which were confirmed by our [honeypots](https://en.wikipedia.org/wiki/Honeypot_(computing)) networks. Basically, honeypots are machines owned by us let vulnerable on purpose so that we keep track of the attackers who try to exploit a vulnerability. 

## Autonomous Systems

An [Autonomous System](https://en.wikipedia.org/wiki/Autonomous_system_(Internet)) can be seen as an organization that is in charge of assigning an address IP to their users. AS can be run by various entities(ISP, cloud providers) which are in charge of distributing IPs over the Internet
`autonomous_systems.csv` contains the descriptions of Autonomous System to which the malicious IP belongs to.
* as_num (Autonomous System Number), int: This is the number of the AS, used as a primary key
* as_name, str: For informational purpose 
* n_ips_reported: The number of unique IPs reported for this AS by all CrowdSec instances, over time.

# Tasks

This home assignment is split into 2 sections : EDA and model training. Feel free to copy-paste the section below at the beginning of the notebook.

## EDA (Exploratory Data Analysis)

In this section, you will dig out the relevant information from the datasets listed above:
* Basic exploration to answer simple questions and get to know the data. You shall answer 3 questions of your choice in the list below. The others are optional and left for the thorough reader (you may also add your own questions which you think are valuable to make sense of the data).
  * What is the distribution of the attack type in terms of the number of IPs reported? 
  * What are the names of the top 10 AS hosting the highest number of malicious IPs? 
  * What are the na
  mes of the top 10 AS hosting malicious IPs which perform the highest number of attack? 
  * What are the 10 watchers IDs which suffered from the highest number of attacks ?
  * Compare the distribution of the average `activity_in_days` and `age_in_days` of the watchers who reported each malicious IPs. with respect to the `is_validated` variable.
* Graph: Build a **simple** graph $G = (V,E)$ where a node $v$ is a malicious IP and an edge $e$ links two malicious IPs if they were reported by the same watcher. Hence the edges are weighted by the number of times 2 malicious IPs were reported by the same watchers.
* Visualization: 
  * Plot a heatmap of the adjacency matrix of the top 40 most connected nodes
  * Plot the subgraph of the 40 most connected nodes 
## Model Training

### Classification - Attack Type

Train a model to classify the type of attack that is reported for each malicious IP. You may train a model on the graph, the adjacency matrix or any features of your choice. In any case, you should follow a standard machine learning training procedure with a train test split.

**Parameter tunning:** Implement a K-fold validation to tune the relevant parameter of your model (if any!)

**Notes:** You can focus on the malicious IPs dataset and optionally use the information in the AS dataset 

### Classification - is_malicious IP_validated

The goal is to develop a model that will automatically *validate* a malicious IP, ended-up redistributing it to the community. We want to validate as much malicious IP as possible while keeping a high level of confidence in the data we redistribute. This is the reason we make sure to have enough confidence in the watchers which reported it. We also use knowledge about the ASN of the malicious IP to trust the reputation of the malicious IP. To put it shortly, a malicious IP will be more likely to be validated according to several criteria: 
* if it were reported by a high number of watchers 
* if the watchers have a high `age_in_days` and `activity_in_days`. 
* if the malicious IP belongs to an AS with a high number of IPs reported

 Hence for this section, you are encouraged to use at least the `watchers.csv` dataset and the `autonomous_systems.csv` dataset, in addition to the malicious IPs dataset. 

Several frameworks are applicable for this section. You can choose to train a model on the available labels only, in a fully-supervised mode and predict the results on the missing labels. You can also choose a semi-supervised framework to complete the missing labels.

**NB: Keep in mind that this is a private hiring test. Please, do not share your responses.**
