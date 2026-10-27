// All site copy and portfolio items live here.
// Everything below is PLACEHOLDER content — replace with the client's real
// details, numbers, testimonials and work when assets arrive.

const brandName = 'SXM.EDITX';
const contactEmail = 'hello@sxmeditx.com';

class SocialLink {
  final String label;
  final String url;
  const SocialLink(this.label, this.url);
}

const socials = [
  SocialLink('Instagram', 'https://instagram.com/'),
  SocialLink('YouTube', 'https://youtube.com/'),
  SocialLink('LinkedIn', 'https://linkedin.com/'),
  SocialLink('X', 'https://x.com/'),
];

class Stat {
  final int value;
  final String suffix;
  final String label;
  const Stat(this.value, this.suffix, this.label);
}

const stats = [
  Stat(500, '+', 'Videos edited'),
  Stat(50, 'M+', 'Views generated'),
  Stat(20, '+', 'Accounts managed'),
  Stat(4, '+', 'Years creating'),
];

const marqueeWords = [
  'Reel Editing',
  'YouTube Edits',
  'Thumbnails',
  'Content Strategy',
  'Social Media Management',
];

// ---------------------------------------------------------------- Creators (Hero Dial)

class Creator {
  final String name;
  final String handle;
  final String role;
  final List<CreatorWork> works;
  final String? svgAsset;
  final String? avatarUrl;
  final String? cutout;

  const Creator(
    this.name,
    this.handle,
    this.role,
    this.works, {
    this.svgAsset,
    this.avatarUrl,
    this.cutout,
  });
}

class CreatorWork {
  final String title;
  final String metric;
  final String tag;

  /// Placeholder colour seed (replace with real thumbnail images later).
  final int colorSeed;

  const CreatorWork(
    this.title,
    this.metric, {
    this.tag = 'Video Edit',
    this.colorSeed = 0,
  });
}

const creators = [
  Creator('Suma', '@suma_creates', 'Lifestyle Creator', [
    CreatorWork(
      'Morning routine that broke the internet',
      '4.2M views',
      tag: 'Viral Reel',
      colorSeed: 0,
    ),
    CreatorWork(
      'Wedding vlog cinematic edit',
      '1.8M views',
      tag: 'Cinematic Vlog',
      colorSeed: 1,
    ),
    CreatorWork(
      'Brand collab reel — skincare',
      '920K views',
      tag: 'Brand Collab',
      colorSeed: 2,
    ),
  ],
    avatarUrl: 'assets/creators/channels4_profile-removebg-preview.png',
    cutout: 'assets/creators/channels4_profile-removebg-preview.png',
  ),
  Creator('Arjun', '@arjun.vlogs', 'Tech Reviewer', [
    CreatorWork(
      '"This phone changed everything"',
      '3.1M views',
      tag: 'Tech Review',
      colorSeed: 3,
    ),
    CreatorWork(
      'Studio tour 2026 — cinematic',
      '1.4M views',
      tag: 'Cinematic Tour',
      colorSeed: 0,
    ),
    CreatorWork(
      'Best budget gadgets — thumbnail set',
      '2.6M views',
      tag: 'Thumbnail Set',
      colorSeed: 1,
    ),
  ]),
  Creator('Priya', '@priya.fitness', 'Fitness Coach', [
    CreatorWork(
      '30-day transformation edit',
      '5.7M views',
      tag: 'Reel Edit',
      colorSeed: 2,
    ),
    CreatorWork(
      'Workout reel — gym aesthetics',
      '2.3M views',
      tag: 'Aesthetic Reel',
      colorSeed: 3,
    ),
    CreatorWork(
      'Meal prep series thumbnails',
      '1.1M views',
      tag: 'Thumbnails',
      colorSeed: 0,
    ),
  ]),
  Creator('Ravi', '@ravi_explores', 'Travel Vlogger', [
    CreatorWork(
      '"48 hours in the wrong city"',
      '3.8M views',
      tag: 'Travel Doc',
      colorSeed: 1,
    ),
    CreatorWork(
      'Drone cinematic — Himalayas',
      '2.9M views',
      tag: 'Drone 4K',
      colorSeed: 2,
    ),
    CreatorWork(
      'Travel gear review thumbnail',
      '1.5M views',
      tag: 'Thumbnail',
      colorSeed: 3,
    ),
  ]),
  Creator('Meera', '@meera.cooks', 'Food Creator', [
    CreatorWork(
      'Street food documentary edit',
      '6.1M views',
      tag: 'Doc Edit',
      colorSeed: 0,
    ),
    CreatorWork(
      'Recipe reel — viral dosa hack',
      '4.4M views',
      tag: 'Viral Reel',
      colorSeed: 1,
    ),
    CreatorWork(
      'Cookbook launch — social campaign',
      '890K views',
      tag: 'Social Promo',
      colorSeed: 2,
    ),
  ]),
];

// ---------------------------------------------------------------- Work

enum WorkCategory { thumbnails, reels, edits, social }

extension WorkCategoryLabel on WorkCategory {
  String get label => switch (this) {
    WorkCategory.thumbnails => 'Thumbnails',
    WorkCategory.reels => 'Reels',
    WorkCategory.edits => 'Video Edits',
    WorkCategory.social => 'Social Media',
  };
}

class WorkItem {
  final WorkCategory category;
  final String title;
  final String client;
  final String metric;

  /// Path to an image in assets/work/ (e.g. 'assets/work/thumb-01.jpg').
  /// Leave null to show a placeholder.
  final String? image;

  /// Optional link (YouTube / Instagram) opened on tap.
  final String? link;

  /// Only for social media cards.
  final String? handle;
  final String? growthFrom;
  final String? growthTo;
  final String? growthUnit;

  const WorkItem({
    required this.category,
    required this.title,
    required this.client,
    required this.metric,
    this.image,
    this.link,
    this.handle,
    this.growthFrom,
    this.growthTo,
    this.growthUnit,
  });

  /// Width / height used to lay the card out.
  double get aspectRatio => switch (category) {
    WorkCategory.reels => 9 / 16,
    WorkCategory.social => 1.0,
    _ => 16 / 9,
  };
}

const workItems = [
  WorkItem(
    category: WorkCategory.thumbnails,
    title: '“I tried living on ₹100 a day”',
    client: 'Creator Name',
    metric: '2.4M views',
  ),
  WorkItem(
    category: WorkCategory.reels,
    title: 'Product launch reel',
    client: 'Brand Name',
    metric: '1.1M plays',
  ),
  WorkItem(
    category: WorkCategory.edits,
    title: 'Documentary-style YouTube edit',
    client: 'Creator Name',
    metric: '18 min',
  ),
  WorkItem(
    category: WorkCategory.social,
    title: 'Full account management',
    client: 'Instagram · 6 months',
    metric: 'Strategy, posting & community',
    handle: '@clientbrand',
    growthFrom: '4.2K',
    growthTo: '86K',
    growthUnit: 'followers',
  ),
  WorkItem(
    category: WorkCategory.thumbnails,
    title: '“The phone nobody talks about”',
    client: 'Tech Channel',
    metric: '860K views',
  ),
  WorkItem(
    category: WorkCategory.reels,
    title: 'Talking-head reel with captions',
    client: 'Coach Name',
    metric: '740K plays',
  ),
  WorkItem(
    category: WorkCategory.edits,
    title: 'Podcast episode edit + clips',
    client: 'Podcast Name',
    metric: '1h 12m',
  ),
  WorkItem(
    category: WorkCategory.thumbnails,
    title: '“48 hours in the wrong city”',
    client: 'Travel Creator',
    metric: '1.3M views',
  ),
  WorkItem(
    category: WorkCategory.social,
    title: 'Content strategy & packaging',
    client: 'YouTube · 4 months',
    metric: 'Ideas, titles, thumbnails & edits',
    handle: '@creatorhandle',
    growthFrom: '9K',
    growthTo: '140K',
    growthUnit: 'subscribers',
  ),
  WorkItem(
    category: WorkCategory.reels,
    title: 'Fast-paced travel reel',
    client: 'Creator Name',
    metric: '2M plays',
  ),
  WorkItem(
    category: WorkCategory.thumbnails,
    title: '“Why everyone is quitting this job”',
    client: 'Finance Channel',
    metric: '990K views',
  ),
  WorkItem(
    category: WorkCategory.edits,
    title: 'Brand commercial cut',
    client: 'Brand Name',
    metric: '60 sec',
  ),
];

// ---------------------------------------------------------------- Services

class Service {
  final String title;
  final String body;
  final List<String> tags;
  const Service(this.title, this.body, [this.tags = const []]);
}

const services = [
  Service(
    'Social Media Management',
    'I run your accounts end to end: content calendar, posting, captions, hashtags, replies and monthly reports.',
    ['Instagram', 'YouTube', 'LinkedIn', 'X', 'Monthly reports'],
  ),
  Service(
    'Reel & Short-form Editing',
    'Strong hooks, tight pacing, animated captions, sound design and edits made for Reels, Shorts and TikTok.',
  ),
  Service(
    'YouTube Video Editing',
    'Long-form edits that hold attention — story structure, b-roll, motion graphics, colour and clean audio.',
  ),
  Service(
    'Thumbnail Design',
    'Bold, clear thumbnails tested against the feed and built to raise CTR. Source files included.',
  ),
  Service(
    'Content Strategy',
    'Audience research, content pillars, video ideas, titles and a plan you can actually follow.',
  ),
];

// ---------------------------------------------------------------- Process

class ProcessStep {
  final String title;
  final String body;
  const ProcessStep(this.title, this.body);
}

const processSteps = [
  ProcessStep(
    'Discovery call',
    "We talk about your goals, your audience and what's working for you right now.",
  ),
  ProcessStep(
    'Strategy',
    'I research your niche and competitors, then plan the ideas, hooks and posting schedule.',
  ),
  ProcessStep(
    'Create',
    "Editing, design and copywriting, all in your brand's look and voice.",
  ),
  ProcessStep(
    'Review & refine',
    "You share feedback and I make revisions quickly until it's right.",
  ),
  ProcessStep(
    'Publish & grow',
    'We go live, track the numbers and use what we learn to improve the next batch.',
  ),
];

// ---------------------------------------------------------------- Reviews

class Review {
  final String quote;
  final String name;
  final String detail;
  const Review(this.quote, this.name, this.detail);
}

const reviews = [
  Review(
    'Our reels went from 2K to 200K views in a month. The hooks and pacing are on another level.',
    'Client Name',
    '1.2M followers',
  ),
  Review(
    "They took over our whole Instagram and I haven't had to think about it since. Reliable, fast and creative.",
    'Brand Founder',
    'D2C Brand',
  ),
  Review(
    'The thumbnails alone pushed our CTR from 4% to 9%. Easily the best investment for the channel.',
    'Creator Name',
    '850K subscribers',
  ),
  Review(
    'Clear communication, always on deadline, and every edit feels like it was made for our audience.',
    'Podcast Host',
    'Weekly podcast',
  ),
  Review(
    "They don't just edit — they think about strategy. Our content finally has a direction.",
    'Coach Name',
    '320K followers',
  ),
];

// ---------------------------------------------------------------- Packages

class Plan {
  final String name;
  final String desc;
  final List<String> features;
  final bool popular;
  const Plan(this.name, this.desc, this.features, {this.popular = false});
}

const plans = [
  Plan(
    'Single Project',
    'One video, a set of reels or a batch of thumbnails.',
    [
      'Thumbnails, reels or long-form',
      '2–3 day turnaround',
      '2 revision rounds',
      'Source files on request',
    ],
  ),
  Plan('Monthly Content', 'A steady flow of edited content every month.', [
    '12–20 reels / shorts a month',
    '2–4 YouTube edits + thumbnails',
    'Content calendar & hooks',
    'Priority turnaround',
  ], popular: true),
  Plan(
    'Full Management',
    'I take care of your social media from start to finish.',
    [
      'Strategy & content pillars',
      'All editing & design',
      'Posting, captions & community',
      'Monthly growth report',
    ],
  ),
];

// ---------------------------------------------------------------- FAQ

class Faq {
  final String q;
  final String a;
  const Faq(this.q, this.a);
}

const faqs = [
  Faq(
    "What's the turnaround time?",
    'Thumbnails take 1–2 days, reels 2–3 days and long-form edits 3–5 days, depending on length. Monthly clients get priority.',
  ),
  Faq(
    'How many revisions do I get?',
    'Every project includes two full revision rounds. Small tweaks after that are usually free. I want you to be happy with the result.',
  ),
  Faq(
    'How do payments work?',
    '50% upfront to book your slot and 50% on delivery. Monthly packages are billed at the start of each month.',
  ),
  Faq(
    'Do you provide source files?',
    'Yes. PSD files for thumbnails and project files for edits are available on request.',
  ),
  Faq(
    'Which platforms do you manage?',
    'Instagram, YouTube, LinkedIn and X. Content can also be adapted for TikTok and Facebook.',
  ),
  Faq(
    'Can you guarantee views?',
    "No one can honestly guarantee views. What I do promise is strategy-led work with proven hooks and pacing, plus regular reviews of what's working.",
  ),
];

const serviceOptions = [
  'Social media management',
  'Reel / short-form editing',
  'YouTube video editing',
  'Thumbnail design',
  'Content strategy',
  'Not sure yet',
];
