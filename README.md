
<p align="center">
  <img src="./images/netmaker.png" width="75%"><break/>
</p>
  
# Welcome to the Netmaker documentation!  

Where is the netmaker documentation hosted?  
- https://docs.netmaker.org  
  
We encourage contributions! Follow the below documentation to build and make changes/additions to the documentation.

# How to build the Netmaker documentation  

0. Install dependencies: make, python3, pip, sphinx, renku-sphinx-theme 
```
(debian instructions, varies by OS)

apt-get install make  
apt-get install python3-sphinx
apt-get install python3-pip
pip install renku-sphinx-theme
pip install markupsafe

```
1. Clone the repo  
`git clone https://github.com/gravitl/netmaker-docs.git`

2. Cd to root of repo and build  
`cd netmaker-docs && make html`

3. Open _build/html/index.html in your browser

# How to contribute to the Netmaker documentation  

Be sure to follow the sphinx documentation while writing your changes: https://documentation-style-guide-sphinx.readthedocs.io/en/latest/style-guide.html

0. Follow the "build" instructions to clone and build the documentation  
1. Create a branch: `git checkout -b <your-doc-change>`
2. Write your changes in the editor of your choice.
3. Build the documentation again to make sure it compiles: `make html` 
4. View it in your browser to make sure it looks good
5. Once ready, commit your code and submit a PR against the develop branch, describing what changes you made.

## Submitting Changes

* Please label your branch using a sensible name.

* Please open a [Pull Request](https://github.com/gravitl/netmaker-docs/compare/develop...master?expand=1) against the develop branch with your branch which clearly describes everything you've done and references any related GitHub issues. 

* Please respond to any feedback in a timely manner. Stale PR's will be closed periodically.
