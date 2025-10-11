// Structured model for efficient O(1) lookups
struct RawBookInfo: Identifiable {
  let id: String  // book_id
  let name: String
  let chapters: [Int]
}

struct RawBibleData {
  // Raw bible data - immediately converted to BookInfo, not stored as static property
  private static func loadBibleData() -> [[String: Any]] {
    return [
      [
        "name": "Genesis",
        "book_id": "GEN",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
          48,
          49, 50,
        ],
      ],
      [
        "name": "Exodus",
        "book_id": "EXO",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        ],
      ],
      [
        "name": "Leviticus",
        "book_id": "LEV",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27,
        ],
      ],
      [
        "name": "Numbers",
        "book_id": "NUM",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
        ],
      ],
      [
        "name": "Deuteronomy",
        "book_id": "DEU",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34,
        ],
      ],
      [
        "name": "Joshua",
        "book_id": "JOS",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
        ],
      ],
      [
        "name": "Judges",
        "book_id": "JDG",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21],
      ],
      [
        "name": "Ruth",
        "book_id": "RUT",
        "chapters": [1, 2, 3, 4],
      ],
      [
        "name": "1 Samuel",
        "book_id": "1SA",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31,
        ],
      ],
      [
        "name": "2 Samuel",
        "book_id": "2SA",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
        ],
      ],
      [
        "name": "1 Kings",
        "book_id": "1KI",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
        ],
      ],
      [
        "name": "2 Kings",
        "book_id": "2KI",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
        ],
      ],
      [
        "name": "1 Chronicles",
        "book_id": "1CH",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29,
        ],
      ],
      [
        "name": "2 Chronicles",
        "book_id": "2CH",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
        ],
      ],
      [
        "name": "Ezra",
        "book_id": "EZR",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      ],
      [
        "name": "Nehemiah",
        "book_id": "NEH",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
      ],
      [
        "name": "Esther",
        "book_id": "EST",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      ],
      [
        "name": "Job",
        "book_id": "JOB",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
        ],
      ],
      [
        "name": "Psalms",
        "book_id": "PSA",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
          48,
          49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70,
          71,
          72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93,
          94,
          95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113,
          114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131,
          132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149,
          150,
        ],
      ],
      [
        "name": "Proverbs",
        "book_id": "PRO",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31,
        ],
      ],
      [
        "name": "Ecclesiastes",
        "book_id": "ECC",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      ],
      [
        "name": "Song of Solomon",
        "book_id": "SOS",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8],
      ],
      [
        "name": "Isaiah",
        "book_id": "ISA",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
          48,
          49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66,
        ],
      ],
      [
        "name": "Jeremiah",
        "book_id": "JER",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
          48,
          49, 50, 51, 52,
        ],
      ],
      [
        "name": "Lamentations",
        "book_id": "LAM",
        "chapters": [1, 2, 3, 4, 5],
      ],
      [
        "name": "Ezekiel",
        "book_id": "EZK",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
          48,
        ],
      ],
      [
        "name": "Daniel",
        "book_id": "DAN",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      ],
      [
        "name": "Hosea",
        "book_id": "HOS",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
      ],
      [
        "name": "Joel",
        "book_id": "JOE",
        "chapters": [1, 2, 3],
      ],
      [
        "name": "Amos",
        "book_id": "AMO",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9],
      ],
      [
        "name": "Obadiah",
        "book_id": "OBA",
        "chapters": [1],
      ],
      [
        "name": "Jonah",
        "book_id": "JON",
        "chapters": [1, 2, 3, 4],
      ],
      [
        "name": "Micah",
        "book_id": "MIC",
        "chapters": [1, 2, 3, 4, 5, 6, 7],
      ],
      [
        "name": "Nahum",
        "book_id": "NAH",
        "chapters": [1, 2, 3],
      ],
      [
        "name": "Habakkuk",
        "book_id": "HAB",
        "chapters": [1, 2, 3],
      ],
      [
        "name": "Zephaniah",
        "book_id": "ZEP",
        "chapters": [1, 2, 3],
      ],
      [
        "name": "Haggai",
        "book_id": "HAG",
        "chapters": [1, 2],
      ],
      [
        "name": "Zechariah",
        "book_id": "ZEC",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
      ],
      [
        "name": "Malachi",
        "book_id": "MAL",
        "chapters": [1, 2, 3, 4],
      ],
      [
        "name": "Matthew",
        "book_id": "MAT",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28,
        ],
      ],
      [
        "name": "Mark",
        "book_id": "MRK",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
      ],
      [
        "name": "Luke",
        "book_id": "LUK",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
        ],
      ],
      [
        "name": "John",
        "book_id": "JOH",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21],
      ],
      [
        "name": "Acts",
        "book_id": "ACT",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28,
        ],
      ],
      [
        "name": "Romans",
        "book_id": "ROM",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
      ],
      [
        "name": "1 Corinthians",
        "book_id": "1CO",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
      ],
      [
        "name": "2 Corinthians",
        "book_id": "2CO",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
      ],
      [
        "name": "Galatians",
        "book_id": "GAL",
        "chapters": [1, 2, 3, 4, 5, 6],
      ],
      [
        "name": "Ephesians",
        "book_id": "EPH",
        "chapters": [1, 2, 3, 4, 5, 6],
      ],
      [
        "name": "Philippians",
        "book_id": "PHP",
        "chapters": [1, 2, 3, 4],
      ],
      [
        "name": "Colossians",
        "book_id": "COL",
        "chapters": [1, 2, 3, 4],
      ],
      [
        "name": "1 Thessalonians",
        "book_id": "1TH",
        "chapters": [1, 2, 3, 4, 5],
      ],
      [
        "name": "2 Thessalonians",
        "book_id": "2TH",
        "chapters": [1, 2, 3],
      ],
      [
        "name": "1 Timothy",
        "book_id": "1TI",
        "chapters": [1, 2, 3, 4, 5, 6],
      ],
      [
        "name": "2 Timothy",
        "book_id": "2TI",
        "chapters": [1, 2, 3, 4],
      ],
      [
        "name": "Titus",
        "book_id": "TIT",
        "chapters": [1, 2, 3],
      ],
      [
        "name": "Philemon",
        "book_id": "PHM",
        "chapters": [1],
      ],
      [
        "name": "Hebrews",
        "book_id": "HEB",
        "chapters": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
      ],
      [
        "name": "James",
        "book_id": "JAM",
        "chapters": [1, 2, 3, 4, 5],
      ],
      [
        "name": "1 Peter",
        "book_id": "1PE",
        "chapters": [1, 2, 3, 4, 5],
      ],
      [
        "name": "2 Peter",
        "book_id": "2PE",
        "chapters": [1, 2, 3],
      ],
      [
        "name": "1 John",
        "book_id": "1JN",
        "chapters": [1, 2, 3, 4, 5],
      ],
      [
        "name": "2 John",
        "book_id": "2JN",
        "chapters": [1],
      ],
      [
        "name": "3 John",
        "book_id": "3JN",
        "chapters": [1],
      ],
      [
        "name": "Jude",
        "book_id": "JUD",
        "chapters": [1],
      ],
      [
        "name": "Revelation",
        "book_id": "REV",
        "chapters": [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
        ],
      ],
    ]
  }

  static let books: [RawBookInfo] = {
    loadBibleData().compactMap { dict in
      guard let id = dict["book_id"] as? String,
        let name = dict["name"] as? String,
        let chapters = dict["chapters"] as? [Int]
      else {
        return nil
      }
      return RawBookInfo(id: id, name: name, chapters: chapters)
    }
  }()

  // Helper function for O(n) lookup - only 66 books so still fast
  static func book(for id: String) -> RawBookInfo? {
    books.first { $0.id == id }
  }

  static let bibleVersions: [[String: String]] = [
    [
      "abbr": "ENGASV",
      "name": "American Standard Bible",
      "short": "ASV",
    ],
    [
      "abbr": "ENGESV",
      "name": "English Standard Version®",
      "short": "ESV",
    ],
    [
      "abbr": "ENGEVD",
      "name": "English Version for the Deaf",
      "short": "EVD",
    ],
    [
      "abbr": "ENGKJV",
      "name": "King James Version",
      "short": "KJV",
    ],
    [
      "abbr": "ENGNAS",
      "name": "New American Standard Bible (NASB)",
      "short": "NAS",
    ],
    [
      "abbr": "ENGREV",
      "name": "Revised Version 1885",
      "short": "REV",
    ],
    [
      "abbr": "ENGWEB",
      "name": "World English Bible",
      "short": "WEB",
    ],
    [
      "abbr": "ENGWM1",
      "name": "World Messianic Version",
      "short": "WM1",
    ],
    [
      "abbr": "ENGWMV",
      "name": "Wycliffe Modern",
      "short": "WMV",
    ],
    [
      "abbr": "ENGNLT",
      "name": "New Living Translation",
      "short": "NLT",
    ],
  ]
  static let bibleVersionsJson: [[String: String]] = [
    [
      "abbr": "ENGASV",
      "name": "American Standard Bible",
      "short": "ASV",
    ],
    [
      "abbr": "ENGESV",
      "name": "English Standard Version®",
      "short": "ESV",
    ],

    [
      "abbr": "ENGKJV",
      "name": "King James Version",
      "short": "KJV",
    ],
    [
      "abbr": "ENGNKJ",
      "name": "New King James Version",
      "short": "NKJV",
    ],
    [
      "abbr": "ENGNAS",
      "name": "New American Standard Bible (NASB)",
      "short": "NAS",
    ],
    [
      "abbr": "ENGNLT",
      "name": "New Living Translation",
      "short": "NLT",
    ],
    [
      "abbr": "ENGREV",
      "name": "Revised Version 1885",
      "short": "REV",
    ],

  ]

  static let bibleCopyrights: [[String: String]] = [
    [
      "abbr": "ENGNLT",
      "name": "New Living Translation",
      "copyright":
        "Holy Bible, New Living Translation, copyright © 1996, 2004, 2015 by Tyndale House Foundation. All rights reserved. Used by permission of Tyndale House Publishers, Carol Stream, Illinois 60188. All rights reserved.",
    ],
    [
      "abbr": "ENGESV",
      "name": "English Standard Version®",
      "copyright":
        "The ESV Bible® (The Holy Bible, English Standard Version®) Copyright © 2001 by Crossway, a publishing ministry of Good News Publishers. ESV® Text Edition: 2007. All rights reserved.",
    ],
    [
      "abbr": "ENGKJV",
      "name": "King James Version",
      "copyright": "Public Domain",
    ],
    [
      "abbr": "ENGNKJ",
      "name": "New King James Version",
      "copyright":
        "The Holy Bible, New King James Version® © 1982 by Thomas Nelson, Inc. All Rights Reserved",
    ],

    [
      "abbr": "ENGREV",
      "name": "Revised Version 1885",
      "copyright": "Public Domain",
    ],
  ]
}
