class Chat {
  final List participants; 
  final List messages;
  final String chatid;

  Chat({required this.chatid, required this.messages, required this.participants ,});

  Chat.dummy():
    participants= [
      'aaaaa',
      'bbbbb'
    ],
    chatid= 'aaaabbbdbb',
    messages= [
      {
        'aaaaa': 'Lorem ipsum dolor sit amet consectetur. ',        
      },
      {
        'bbbbb': 'Lorem ipsum dolor sit amet consectetur. ',        
      },
      {
        'aaaaa': 'Lorem ipsum dolor sit amet consectetur. ',        
      },
      {
        'bbbbb': 'Lorem ipsum dolor sit amet consectetur. ',        
      },
      {
        'bbbbb': 'Lorem ipsum dolor sit amet consectetur. ',        
      },

    ];
}