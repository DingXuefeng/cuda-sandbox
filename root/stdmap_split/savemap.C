#include <map>
#include <string>
#include <TFile.h>
#include <TTree.h>
#include "TStreamerInfo.h"
#pragma link off all globals;
#pragma link off all classes;
#pragma link off all functions;
#pragma C++ class std::map<std::string,Element*>+;
#pragma C++ class std::map<std::string,int>+;
struct Element {
  double x;
  double y;
  double z;
};
struct info {
  std::map<std::string,Element*> elements;
  std::map<std::string,int> simple_elements;
  std::vector<const Element*> e;
};
void savemap() {
//  TFile *file = TFile::Open("save.root","RECREATE");
  TTree *tree = new TTree("t","t");
  info *obj = new info {{{"hi", new Element{1,1,1}},{"h",new Element { 3,3,3}}} ,{{"hi",1},{"m",2}} , { new Element { 1,2,3}, new Element { 2,3,3} }};
  tree->Branch("t","info",&obj,84000,9999);
  tree->Fill();

  (obj->elements)["hi"] = new Element { 1,2,3 };
  (obj->elements)["oh"] = new  Element { 2,3,1 };
  std::vector<Element*> e;
  e.push_back( obj->elements["hi"] );
//  obj->e = e;
  obj->simple_elements["hh"] = 3;
  obj->simple_elements["hd"] = 4;
  (obj->elements)["h"] = new Element { 9,2,3 };
  (obj->elements)["o"] =new  Element { 12,3,1 };
  obj->simple_elements["x"] = 5;
  tree->Fill();
  tree->Print();
  tree->Show(0);
  tree->Show(1);
TClass *cl = TClass::GetClass("info");
  TStreamerInfo* sinfo = tree->BuildStreamerInfo(cl, obj, false);
sinfo->ls();
//  file->Close();
}
