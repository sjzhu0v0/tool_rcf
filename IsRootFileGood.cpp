#include "TFile.h"
#include "iostream"

using namespace std;

int main(int argc, char *argv[]) {
  if (argc != 2) {
    cout << "Usage: IsRootFileGood <filename>" << endl;
    return 1;
  }

  TFile *f = TFile::Open(argv[1]);
  if (f == 0) {
    cout << "File " << argv[1] << " does not exist" << endl;
    return 1;
  }

  if (f->IsZombie()) {
    cout << "File " << argv[1] << " is a zombie" << endl;
    return 1;
  }

  cout << "File " << argv[1] << " is OK" << endl;
  return 0;
}