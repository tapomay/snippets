# free unused memory: http://askubuntu.com/questions/507699/why-does-ubuntu-not-seem-to-release-memory
0 22 * * * sync & sysctl -w vm.drop_caches=3
