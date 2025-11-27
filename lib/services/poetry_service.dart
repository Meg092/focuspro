import '../models/poem.dart';

class PoetryService {
  static final List<Poem> allPoems = [
    Poem(
      id: 1,
      title: 'The Road Not Taken',
      author: 'Robert Frost',
      year: 1916,
      lines: [
        'Two roads diverged in a yellow wood,',
        'And sorry I could not travel both',
        'And be one traveler, long I stood',
        'And looked down one as far as I could',
        'To where it bent in the undergrowth;',
      ],
    ),
    
    Poem(
      id: 2,
      title: 'Stopping by Woods',
      author: 'Robert Frost',
      year: 1923,
      lines: [
        'Whose woods these are I think I know.',
        'His house is in the village though;',
        'He will not see me stopping here',
        'To watch his woods fill up with snow.',
      ],
    ),
    
    Poem(
      id: 3,
      title: 'I Wandered Lonely as a Cloud',
      author: 'William Wordsworth',
      year: 1807,
      lines: [
        'I wandered lonely as a cloud',
        'That floats on high over vales and hills,',
        'When all at once I saw a crowd,',
        'A host, of golden daffodils;',
      ],
    ),
    
    Poem(
      id: 4,
      title: 'The Tyger',
      author: 'William Blake',
      year: 1794,
      lines: [
        'Tyger Tyger, burning bright,',
        'In the forests of the night;',
        'What immortal hand or eye,',
        'Could frame thy fearful symmetry?',
      ],
    ),
    
    Poem(
      id: 5,
      title: 'Ozymandias',
      author: 'Percy Bysshe Shelley',
      year: 1818,
      lines: [
        'I met a traveller from an antique land,',
        'Who said—Two vast and trunkless legs of stone',
        'Stand in the desert... Near them, on the sand,',
        'Half sunk a shattered visage lies,',
      ],
    ),
    
    Poem(
      id: 6,
      title: 'Sonnet 18',
      author: 'William Shakespeare',
      year: 1609,
      lines: [
        'Shall I compare thee to a summers day?',
        'Thou art more lovely and more temperate:',
        'Rough winds do shake the darling buds of May,',
        'And summers lease hath all too short a date;',
      ],
    ),
    
    Poem(
      id: 7,
      title: 'If',
      author: 'Rudyard Kipling',
      year: 1910,
      lines: [
        'If you can keep your head when all about you',
        'Are losing theirs and blaming it on you,',
        'If you can trust yourself when all men doubt you,',
        'But make allowance for their doubting too;',
      ],
    ),
    
    Poem(
      id: 8,
      title: 'The Raven',
      author: 'Edgar Allan Poe',
      year: 1845,
      lines: [
        'Once upon a midnight dreary, while I pondered, weak and weary,',
        'Over many a quaint and curious volume of forgotten lore—',
        'While I nodded, nearly napping, suddenly there came a tapping,',
        'As of some one gently rapping, rapping at my chamber door.',
      ],
    ),
    
    Poem(
      id: 9,
      title: 'Invictus',
      author: 'William Ernest Henley',
      year: 1875,
      lines: [
        'Out of the night that covers me,',
        'Black as the pit from pole to pole,',
        'I thank whatever gods may be',
        'For my unconquerable soul.',
      ],
    ),
    
    Poem(
      id: 10,
      title: 'Do Not Go Gentle',
      author: 'Dylan Thomas',
      year: 1947,
      lines: [
        'Do not go gentle into that good night,',
        'Old age should burn and rave at close of day;',
        'Rage, rage against the dying of the light.',
      ],
    ),
    
    Poem(
      id: 11,
      title: 'A Dream Within A Dream',
      author: 'Edgar Allan Poe',
      year: 1849,
      lines: [
        'Take this kiss upon the brow!',
        'And, in parting from you now,',
        'Thus much let me avow—',
        'You are not wrong, who deem',
        'That my days have been a dream;',
      ],
    ),
    
    Poem(
      id: 12,
      title: 'Fire and Ice',
      author: 'Robert Frost',
      year: 1920,
      lines: [
        'Some say the world will end in fire,',
        'Some say in ice.',
        'From what I have tasted of desire',
        'I hold with those who favor fire.',
      ],
    ),
    
    Poem(
      id: 13,
      title: 'The New Colossus',
      author: 'Emma Lazarus',
      year: 1883,
      lines: [
        'Give me your tired, your poor,',
        'Your huddled masses yearning to breathe free,',
        'The wretched refuse of your teeming shore.',
        'Send these, the homeless, tempest-tossed to me,',
      ],
    ),
    
    Poem(
      id: 14,
      title: 'Hope is the Thing with Feathers',
      author: 'Emily Dickinson',
      year: 1891,
      lines: [
        'Hope is the thing with feathers',
        'That perches in the soul,',
        'And sings the tune without the words,',
        'And never stops at all,',
      ],
    ),
    
    Poem(
      id: 15,
      title: 'Because I Could Not Stop for Death',
      author: 'Emily Dickinson',
      year: 1890,
      lines: [
        'Because I could not stop for Death –',
        'He kindly stopped for me –',
        'The Carriage held but just Ourselves –',
        'And Immortality.',
      ],
    ),
    
    Poem(
      id: 16,
      title: 'Annabel Lee',
      author: 'Edgar Allan Poe',
      year: 1849,
      lines: [
        'It was many and many a year ago,',
        'In a kingdom by the sea,',
        'That a maiden there lived whom you may know',
        'By the name of Annabel Lee;',
      ],
    ),
    
    Poem(
      id: 17,
      title: 'She Walks in Beauty',
      author: 'Lord Byron',
      year: 1814,
      lines: [
        'She walks in beauty, like the night',
        'Of cloudless climes and starry skies;',
        'And all that is best of dark and bright',
        'Meet in her aspect and her eyes;',
      ],
    ),
    
    Poem(
      id: 18,
      title: 'How Do I Love Thee?',
      author: 'Elizabeth Barrett Browning',
      year: 1850,
      lines: [
        'How do I love thee? Let me count the ways.',
        'I love thee to the depth and breadth and height',
        'My soul can reach, when feeling out of sight',
        'For the ends of being and ideal grace.',
      ],
    ),
    
    Poem(
      id: 19,
      title: 'Trees',
      author: 'Joyce Kilmer',
      year: 1913,
      lines: [
        'I think that I shall never see',
        'A poem lovely as a tree.',
        'A tree whose hungry mouth is prest',
        'Against the earths sweet flowing breast;',
      ],
    ),
  ];
  
  static Poem? getPoemById(int id) {
    try {
      return allPoems.firstWhere((poem) => poem.id == id);
    } catch (e) {
      return null;
    }
  }
  
  static List<Poem> getAllPoems() {
    return allPoems;
  }
}
