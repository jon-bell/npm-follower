# Analysis of Security of the NPM Ecosystem Historically

## Security Vulnerabilities

- Have install scripts become more or less prevelant over time? Are they only added, or also removed from packages? What are the most frequent commands? {M}
  
  Methodology: let's consider two metrics: a) frequency of packages with at least one version having an install script, and b) frequency of packages where the latest version has an install script.

  We can then compute a) and b) for every month since the start of NPM. 
  Interpretations of a) and b): Metric a) gives an upper bound on how useful install scripts are for developers: __% of packages found it useful to use install scripts at somepoint in their lifecycle. Metric b) says roughly how likely you are to be forced to run an install script if installing a random package at a given point in time.

  Next, let's look at *changes* to install scripts. What % of packages contain in their history these types of changes: 1) add install script, 2) delete install script, 3) change install script? 
  Let's manually examine a few of these in popular packages, and see why developers made those changes.

** Jon **: What about cases where the install script calls script B, then script B changes? This should still count as "change install script," right?

  Finally, what's the content of install scripts? Let's count command / word occurrences within install scripts. We'll only count a word once for every time it occurrs in any version of a package.

** Jon **: What is the baseline for this? What can we conclude by seeing the counts?

  Note: for all the above, we should ignore beta versions, etc.


- How quickly do authors release updates in response to CVEs? {A, M}
  
  Methodology: for each CVE with a patch, we can look at the time between the publish time of the CVE and the publish time of the patched version. We can then look at the distribution of times between CVE publication and fix.
  We can segment this on both the CVE side (severity, vector, etc.) and on the package side (popularity).

- ~~How well are CVEs updated to track fixes or non-fixes to packages? {A, ???}~~ (Federico says they get updated, but do they really?)

## Dependency Structure

- After an update is published, how quickly do downstream packages update to receive it?  {M}
  - Is this different between security updates vs. feature updates?
  
  Methodology: this is probably one of the more complicated ones. In many cases, downstream dependencies *automatically* receive the update,
  if their version constraint allows it. Suppose we are considering an update of package A from version V1 to V2, and we wish to see how often it is adopted.
  First, we get all the packages (B) who's latest version (W1) prior to V2 being published had a dependency on A with constraint C satisfying V1. We then have 2 cases. If 
  C also satisfies V2, then this counts as an *automatic update*. If C does not satisfy V2, then we attempt to find the first version W2 after W1 which does satisfy V2.
  If we find such a version, then we count this as a *manual update*, and we find the time difference between W2 and V2. If we do not find such a version, then we count this as a *non-update*.

  We'd then need to do this for all packages, and then aggregate the results. We can also segment this on upstream package popularity, downstream package popularity, dependency type (prod vs. dev), and update type (security patch vs. other).


## Code changes & semver

Each semver update is one of 4 *update types*: bug (1.1.1 -> 1.1.2), minor (1.1.1 -> 1.2.0), major (1.1.1 -> 2.0.0), or other (betas, and weird crap).

- How frequent are each update type? {M}

  Methodology: for each package, we determine which percentage of its updates are bug, minor, or major (discarding other). We then aggregate this across all packages.

- Among each update type:
  - what files are typically changed? {M, T}
  - how large are the diffs? {M, T}
  - lower-bound on non-breaking changes? {M, T} (too hard for now)

  Methodology: For each update, we compute its diff D. From D, we find:
  - how many files are modified (N_F)
  - how many lines are modified/added/removed (N_M, N_A, N_R)
  - which files are modified (S_F)
  - which file extensions are modified (S_E)

  We then normalize these metrics per-package (as was done above), and aggregate across all packages. We also join each update with the update type (determined above),
  and segment by update type. 

  Finally, for each update we can also classify it as definitely non-breaking, or not.
  If only `package.json` is modified, and non-code files (`.md`, etc.) are modified, then it's non-breaking (not quite, for `package.json` we have to check that the dependencies are changed in a non-breaking way, but that's not too hard).
  We could try to do harder things, but likely won't have time.








# RQs for paper (OLD)

We focus all RQs around historical analysis: how did X change over time, or how did X change in response to Y?

We have 4 themes, each of which we analyze historically.

## Security Vulnerabilities

- Have install scripts become more or less prevelant over time? Are they only added, or also removed from packages? {M}
- How quickly do authors release updates in response to CVEs? {A, ???}
- How well are CVEs updated to track fixes or non-fixes to packages? {A, ???}

## Dependency Structure

- How common are: changing version constraints vs. adding new packages vs. deleting packages  {M}
- After an update is published, how quickly do downstream packages update to receive it?  {M}
- How are dependencies updated to patch vulnerabilities in dependencies?  {M, A}
- Which packages are most important to the ecosystem, and how has this changed over time? {M}

## Use of language features

How have developers used features in JS / TS over time?

- After the release of TypeScript, how rapidly have packages adopted types? Has the rate of adoption sped up or slowed down? {M}
- For packages which adopt types, how do their types evolve over time? {M, T}
- After X (classes, ES modules, async/await, etc.) is introduced to JS, how commonly is it used? {M, T}


## Code changes & semver

Each semver update is one of 4 *update types*: bug (1.1.1 -> 1.1.2), minor (1.1.1 -> 1.2.0), major (1.1.1 -> 2.0.0), or other (betas, and weird crap).

- How frequent are each update type? {M}
- Among each update type:
  - what files are typically changed? {M, T}
  - are the changes breaking? {M, T}
  - how large are the diffs? {M, T}


# NPM Dataset Questions (OLD!)



## Security Questions
- How common are install scripts? {M}
- What do install scripts usually do? {M}
- CVEs and CVSSs for packages {M, A}



## Typing (TS, etc.) Questions
- How are typed packages published to NPM? {M, T}
- How many packages (JS?) typecheck with `tsc`? {M, T}
- Measure something about migrations of packages from untyped to typed {M, T}


## Characteristics of code updates
- Note: these things should be conditional on non-autogenerated code?
- What files get changed?  {M, T}
- Are there updates where the only difference is dependency / metadata changes?  {M, T}
- How often do updates: change actual executable code? Just change types? Just add only new code?  {M, T}
- And does that match with semver?  {M, T}


## Code property questions
- How many use `eval`? Past / present  {M, T}
- Replication of 2011 article. The one where they scrape JS from top websites and look for `eval`, etc. https://link.springer.com/chapter/10.1007/978-3-642-22655-7_4   {M, T}
- How commonly does autogenerated code occur? {M, T}
- How often are binaries included in packages? Or other types of weird things (GIFs)? {M, T}
- Changes to use of language features? {M, T, R?}
    + require vs. import
    + async/await
    + arrow functions
    + classes
    + etc.


## How do dependencies change over time?
- How common are: changing version constraints vs. adding new packages vs. deleting packages  {M}
- After an update is published, how quickly do downstream packages update to receive it?  {M}
- How are dependencies updated to patch vulnerabilities in dependencies?  {M, A}


## Ranking of packages
- Which packages are "important" to the ecosystem? (see trivial packages paper, "technical plus factor")   {M, D?}






# Data that we have

## Metadata {M}
- 2.6 million packages
- 28 million package-version pairs, each one has a url to the repo {R}

## Tarballs {T}
- 28 million tarballs, one for each p-v pair

## GH Advisors (could scrape) {A}
- We could scrape the GH advisory database. It's pretty easy to do.

## Download metrics {D}
- We have download metrics scraped for all packages.

## Repos {R}
- We have repos linked for all package-version pairs





# Related Work

## A Measurement Study of Google Play - https://dl.acm.org/doi/pdf/10.1145/2591971.2592003

- They don't have historical data like we do, they only have data since when they started mining
- They actually reverse engineered the API by disassembling Google Play
- Mined number of free apps vs paid apps over a time span
  - answers: how does the free/paid app ratio change between date x and y?
- Categorized apps, showed ratio of free/paid for each category (one app can belong to only 1 category)
- Showed how star-ratings change based on the app being free/paid and the amount of downloads the app has
- Showed how the number of downloads of an app affects the probability of the app depending on certain libraries (more downloads, more native lib prob)
  - By checking which libraries it depends on, they inferred things like:
    - Which advertisement platform they used (if any)
    - Which social platform is the app connected to (if any)
    - ...
- They showed the amount of duplicate apps in the google play store
- They went through the source code of each app and looked for leaking API secret keys, and found quite a few

## The Evolution of Type Annotations in Python: An Empirical Study - https://www.software-lab.org/publications/fse2022_type_study.pdf

- They use github to mine repos
- They analyzed how many projects are using type annotations in Python over time
- Showed how many people are using which kind of annotation (function argument, return and variable annotations)
- Showed how much of these annotations exist in the projects
  - do they fully annotate everything as if python was a statically typed language?
  - do they occasionally type things here and there?
  - did they have no types before, but then decided to type annotate everything after?
- Out of all the commits in these projects, how many commits where type-related?
- Showed positive relation between type errors in a project and the number of type annotations in the project.
  - (remember: you can ignore type errors in python)


## https://arxiv.org/pdf/1709.04638.pdf

- they mined 169,964 npm packages


## https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9387131

- this one seems to only analyze 15,000 packages
- but has a lot of information on them


## https://arxiv.org/abs/2210.07482
