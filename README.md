# MD-28799 Moderna Supply Demand ML P2 Data Models

# Installing

Run this from your command line of choice. NOTE- this assumes you have python installed on your machine.

```
pipenv install
pipenv run dbt deps
```

That's it.

# Configuring

You will need to configure your `profiles.yml` file to connect to your warehowse instance.  This file is located in the `dbt` directory.  You will need to add the following to the `profiles.yml`

# Running

This assumes you have followed the instructions in [Installing](#installing) and [Configuring](#configuring).

Now that you have installed and configured `dbt` you can run it using the [`activate`](activate) convenience script provided in this repository.  See the [DEVELOPING](DEVELOPING.md) instructions for more detail.

To create the models run this command:

```
./activate dbt run
```

If you are using a global environment config, you can simply `dbt run` without running `activate`.

Pay attention to the log output as it will identify any issues that occur long the way.  A more detailed log is stored at `logs/dbt.log`.

<hr>

#### IMPORTANT NOTE

If you are running on a Windows machine, you need to use a `bash`-like command line for the `activate` script to work properly.  If you do not have one installed (Git Bash, WSL, etc), you can take advantage of `pipenv`'s built in `dotenv` integration and use the [sample.env](sample.env) file to set the variable.  Copy it to `.env` and it'll load automatically.

```
pipenv run dbt run
```

If you get tired of that, step into the environment with `pipenv shell`.  This loads the env variable at the start.

```
pipenv shell
dbt run
```

Use `exit` to get out of the virtual environment.

## Loading external sources

The external loading process uses `dbt-external-tables` with a slight modification (forked) to handle our specific DMS use case. Note: you need the `ops_admin` role to be able to execute these commands.  There is no DEV mode for this operation, so be careful with what you're running.

To run all external loads:

```
./activate dbt run-operation stage_external_sources
```

To run all external loads and force a reload:

```
./activate dbt run-operation stage_external_sources --vars "ext_full_refresh: true"
```

Be careful with a full reload since Snowpipe will only load the most recent seven days of data by default.

To run a specific external load and force a refresh:

```
./activate dbt run-operation stage_external_sources --vars "ext_full_refresh: true" --args "select: the_model_name"
```

See <https://github.com/dbt-labs/dbt-external-tables> for more details.

## Versioning

This repo is equipped to run automatically with the `python-semantic-release` package.  Configure CircleCI with deploy permissions to push back to GitHub (create a shared key).  Once done, on merge to `main`, CircleCI will automatically build and run dbt for you.

This requires using [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) when writing commit messages to automatically update the version number according to [Semantic Versioning](https://semver.org) logic.  Some examples:

Guidelines:

* `main` is merge-only.  Never work directly on that branch. It contains your last-known, best version of the code base.  Client deliverables should be deployed on `main` before producing the final result.
* Designate code owner(s) to be responsible for integrating different teammate's code.  Encourage small pull requests that are easy to consolidate.  Discourage long-lived branches that keep parallel versions of the code.  The longer you have code on a separate branch, the higher likelihood you have of merge conflicts.  No one likes merge conflicts.
* Commit to fast pull request reviews.  Read the code, ask questions, but don't let it slow you down too much.  If something is broken, do another PR to fix it.
* Use branching to organize changes together.  A branch should be based on a specific update not based on you. Examples:
  * `feature/add-new-analysis`
  * `add-new-analysis`
  * `feature/update-user-time-series-analysis-with-feedback`
* Always prefix your commit with `feat:`, `fix:`, `docs:`, etc.  Examples:
  * `feat: update the important model to include more important data`
  * `fix: metric calculation for important measure is missing an key value`
* Keep commits small and [atomic](https://www.aleksandrhovhannisyan.com/blog/atomic-git-commits/). If you have to use "and" in your commit, it does too much.

If you do this, `semantic-release` will write your changelog, bump the version number in your `dbt_project.yml` and deploy to Snowflake _automatically_.  Work smarter, not harder.  Trust the versioning system.  You don't have to create your own.

Why Semantic Versioning?  Every time you merge to `main`

## Resources

* Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)

* Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
* Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
* Find [dbt events](https://events.getdbt.com) near you
* Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## Template

This repository was rendered using version 0.4.0 of the [KS Cookiecutter DBT](https://github.com/Keystone-Strategy/ks-cookiecutter-dbt) template.
