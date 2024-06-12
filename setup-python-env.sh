set -e
rm -rf myenv
python3.10 -m venv myenv
source myenv/bin/activate
#CFLAGS=-I/usr/include/tirpc python -m pip install 'https://repo.hops.works/master/pydoop/pydoop-2.0.0.tar.gz'
CFLAGS=-I/usr/include/tirpc python -m pip install 'https://repo.hops.works/dev/salman/pydoop-2.0.0.tar.gz'
