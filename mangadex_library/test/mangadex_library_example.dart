import 'package:mangadex_library/mangadexServerException.dart';
import 'package:mangadex_library/mangadex_library.dart' as lib;

void main() {
  printFilenames();
}

void printFilenames() async {
  // this function, needs a mangadex account username and password supplied
  // to retrive login token
  var username = 'riksantra'; // Put your username here
  var password = 'Sikkim123.'; // Put your password here

  //The line below uses the login function and takes in
  //two String parameters, username and password and returns
  //an instance of the Login class
  try {
    var loginData = await lib.login(username, password);
    var token = loginData!.token
        .session; // this sets the token variable to store the session token obtained using
    //the login function, it is a String value.
    // The token is used to access various sections and therefore it is recommended to be made accessible at all times.

    var searchData = await lib.search(
        query:
            'oregairu'); //This is a search function that queries mangadex for the name of a manga
    // it returns a Search class instance
    // For now, it searches for the Oregairu manga. You may replace the String value with your desired query.

    var mangaID = searchData!.data[0]
        .id; // this line gets the manga ID from the instance of the Search we just obtained
    //for demonstration we are talking the manga ID of only the first search result
    //Manga ID is unique to every manga and therefore is required to obtain any information regarding it
    //For example, chapter pages and thumbnails.
    var chapterData = await lib.getChapters(
        mangaID); //This function returns an instance of the ChapterData class,
    // it contains info on all the chapters of the manga ID it has been provided.

    var chapterID = chapterData!.data[0]
        .id; // This line sets the chapterID variable to the chapter id of
    // the first chapter from the chapterData we just got.
    //Every chapter has a usique chapter ID and a chapter Hash
    //Chapter ID is required to access info of the desired chapter.
    //Chapter Hash is required for requesting manga pages.
    var singleChapterData = await lib.getChapterDataByChapterId(chapterID);
    var filenames = singleChapterData.chapter.data;
    var baseUrl = singleChapterData.baseUrl;
    // the filenames variable stores the name of all files in a manga chapter
    for (var i = 0; i < filenames.length; i++) {
      print(lib.constructPageUrl(
          baseUrl,
          token,
          true,
          singleChapterData.chapter.hash,
          singleChapterData.chapter.dataSaver[i]));
    }
    // this for loop prints the url to all the pages in the provided chapters.
  } on MangadexServerException catch (e) {
    e.info.errors.forEach((element) {
      print(element
          .title); // print error details if a server exception occurs (like invalid username or password)
      print(element.detail);
    });
  }
}
