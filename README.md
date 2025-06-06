Triage
======

ML/Data Science Toolkit for Social Good and Public Policy Problems

[![image](https://travis-ci.com/dssg/triage.svg?branch=master)](https://travis-ci.org/dssg/triage)
[![image](https://codecov.io/gh/dssg/triage/branch/master/graph/badge.svg)](https://codecov.io/gh/dssg/triage)
[![image](https://codeclimate.com/github/dssg/triage.png)](https://codeclimate.com/github/dssg/triage)

Building ML/Data Science systems requires answering many design questions, turning them into modeling choices, which in turn define and machine learning models. Questions such as cohort selection, unit of analysis determination, outcome determination, feature (explanatory variables or predictors) generation, model/classifier training, evaluation, selection, bias audits, interpretation, and list generation are often complicated and hard to make design choices around a priori. In addition, once these choices are made, they have to be combined in different ways throughout the course of a project.

Triage is designed to:

- Guide users (data scientists, analysts, researchers) through these design choices by highlighting critical operational use questions.
- Provide an integrated interface to components that are needed throughout a ML/data science project workflow.

## Getting Started with Triage

- Are you completely new to Triage? Run through a quick tutorial hosted on google colab (no setup necessary) to see what triage can do!  [Tutorial hosted on Google Colab](https://colab.research.google.com/github/dssg/triage/blob/master/example/colab/colab_triage.ipynb)
- Run it locally on an [example problem and data set from Donors Choose](https://github.com/dssg/donors-choose)
- [Dirty Duck Tutorial](https://dssg.github.io/triage/dirtyduck/) - Want a more in-depth walk through of triage's functionality and concepts? Go through the dirty duck tutorial that you can install on your local machine  with sample data
- [QuickStart Guide](https://dssg.github.io/triage/quickstart/) - Try Triage out with your own project and data
- [Triage Documentation Site](https://dssg.github.io/triage/) - Used Triage before and want more reference documentation?
- [Development](https://github.com/dssg/triage#development) - Contribute to Triage development.

## Installation

To install Triage locally, you need:

- Ubuntu/RedHat
- Python 3.9+
- A PostgreSQL 9.6+ database with your source data (events,
  geographical data, etc) loaded.
  - **NOTE**: If your database is PostgreSQL 11+ you will get some
    speed improvements. We recommend updating to a recent
    version of PostgreSQL.
- Ample space on an available disk (or for example in Amazon Web
  Services's S3) to store the matrices and models that will be created for your
  experiments

We recommend starting with a new Python virtual environment and pip installing triage there.
```bash
$ virtualenv triage-env
$ . triage-env/bin/activate
(triage-env) $ pip install triage
```
If you get an error related to pg_config executable, run the following command (make sure you have sudo access):
```bash
(triage-env) $ sudo apt-get install libpq-dev python3.9-dev
```
Then rerun pip install triage
```bash
(triage-env) $ pip install triage
```
To test if triage was installed correctly, type:
```bash
(triage-env) $ triage -h
```


## Data
Triage needs data in a postgres database and a configuration file that has credentials for the database. The Triage CLI defaults database connection information to a file stored in 'database.yaml' (example in [example/database.yaml](https://github.com/dssg/triage/blob/master/example/database.yaml)).

If you don't want to install Postgres yourself, try `triage db up` to create a vanilla Postgres 12 database using docker. For more details on this command, check out [Triage Database Provisioner](db.md)

## Configure Triage for your project

Triage is configured with a config.yaml file that has parameters defined for each component. You can see some [sample configuration with explanations](https://github.com/dssg/triage/blob/master/example/config/experiment.yaml) to see what configuration looks like.

## Using Triage

1. Via CLI:
```bash

triage experiment example/config/experiment.yaml
```
2. Import as a python package:
```python
from triage.experiments import SingleThreadedExperiment

experiment = SingleThreadedExperiment(
    config=experiment_config, # a dictionary
    db_engine=create_engine(...), # http://docs.sqlalchemy.org/en/latest/core/engines.html
    project_path='/path/to/directory/to/save/data' # could be an S3 path too: 's3://mybucket/myprefix/'
)
experiment.run()
```

There are a plethora of options available for experiment running, affecting things like parallelization, storage, and more. These options are detailed in the [Running an Experiment](https://dssg.github.io/triage/experiments/running/) page.

## Development

Triage was initially developed at [University of Chicago's Center For Data Science and Public Policy](http://dsapp.uchicago.edu) and is now being maintained at Carnegie Mellon University.

To build this package (without installation), its dependencies may
alternatively be installed from the terminal using `pip`:

    pip install -r requirement/main.txt

### Testing

To add test (and development) dependencies, use **test.txt**:

    pip install -r requirement/test.txt [-r requirement/dev.txt]

Then, to run tests:

    pytest

### Development Environment

To quickly bootstrap a development environment, having cloned the
repository, invoke the executable `develop` script from your system
shell:

    ./develop

A "wizard" will suggest set-up steps and optionally execute these, for
example:

    (install) begin

    (pyenv) installed

    (python-3.9.10) installed

    (virtualenv) installed

    (activation) installed

    (libs) install?
    1) yes, install {pip install -r requirement/main.txt -r requirement/test.txt -r requirement/dev.txt}
    2) no, ignore
    #? 1

### Contributing

If you'd like to contribute to Triage development, see the [CONTRIBUTING.md](https://github.com/dssg/triage/blob/master/CONTRIBUTING.md) document.

