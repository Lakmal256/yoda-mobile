extension Counter on String{
  int countWords(){
    /// count without empty words
    return split(" ").where((text) => text != "").length;
  }

  int countCharacters(){
    /// count without empty characters
    return replaceAll(" ", "").length;
  }
}