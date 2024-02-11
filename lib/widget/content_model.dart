class UnboardingContent{
  String image;
  String title;
  String description;
  UnboardingContent({required this.description, required this.image, required this.title});

}

List<UnboardingContent> contents=[

  UnboardingContent(description: 'Pick your Water Station\n', image: "images/logo.png", title: 'Select from your \\n Nearest Water Station'),
  UnboardingContent(description: 'You can pay on Cash on Delivery', image: "images/logo.png", title: 'Convenient'),
  UnboardingContent(description: 'Delivery your water', image: "images/logo.png", title: 'Quick Delivery'),
];
