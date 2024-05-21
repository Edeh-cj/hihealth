String localeTranslation(String title, Language language){

 if(language == Language.hausa){ 
    return switch (title.toLowerCase()) {
      'specialist doctors' => 'kwararren likita',
      'online doctors' => 'online likitoci',
      'recommendations' => 'Nasiha',
      'see all' => 'gani duka',
      'message' => 'rubuta masa',
      String() => '-'
    };
  } else if (language == Language.igbo){
    return switch (title.toLowerCase()) {
      'specialist doctors' => 'ọkachamara dọkịta',
      'online doctors' => "ndị dọkịta n'ịntanetị",
      'recommendations' => 'Akwadoro',   
      'see all' => 'hụ ihe niile',
      'message' => 'dee ya ozi', 
      String() => '-'
    };

  } else if (language == Language.yoruba){
    return switch (title.toLowerCase()) {
      'specialist doctors' => 'dokita alamọja',
      'online doctors' => 'online onisegun',
      'recommendations' => 'Ti ṣe iṣeduro',
      'see all' => 'wo gbogbo e',
      'message' => 'ọrọ rẹ',
      String() => '-'
    };
  } else {
    return title;
  }
}

Language stringToLanguage(String? langString){
  if (langString != null) {
    return switch (langString.toLowerCase()) {
      'hausa' => Language.hausa,
      'yoruba' => Language.yoruba,
      'igbo' => Language.igbo,
      String() => Language.yoruba
    };
  } else {
    return Language.yoruba;
  }

}


enum Language {igbo, hausa, yoruba}