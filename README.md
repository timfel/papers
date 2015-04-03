### Usage

To clone the paper you want, and not pull down everything, use the following:
```bash
PAPER=paper
git clone --single-branch --branch $PAPER git@github.com:timfel/papers.git $PAPER
cd $PAPER
git config --local --replace-all remote.origin.fetch +refs/heads/${PAPER}:refs/remotes/origin/${PAPER}
```

### About
My Papers. Older papers are on the many-together branch, newers have
their own (orphan) branch. Some papers are shared in other repos. Some of those other repos:

* cdg	tim@tinlizzie.org:/git/cdg-c
* mathesis	mathesis@code.hpi.uni-potsdam.de:mathesis.git
* squeakjs-paper	git@github.com:timfel/squeakjs-paper
* versioninglively	versioninglively@code.hpi.uni-potsdam.de:versioninglively.git
