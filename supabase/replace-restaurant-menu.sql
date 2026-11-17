-- Manual menu replacement. Run only when ready to replace the live menu.
-- Requires the Spice Garden admin schema. Supabase SQL Editor runs as the project owner.
-- Existing dishes, their photo links, and collection memberships are replaced.
-- Uploaded Storage objects remain available for the app's normal photo cleanup.
-- Highest numeric listed price wins; a duplicate stays in the category of that price.
-- Equal-priced repeated listings keep their first category. Rows with no numeric
-- price display the app's “Ask staff” label. Mixed veg/chicken listings are tagged
-- non-veg; two dishes with unclear ingredients are imported as unpublished drafts.
begin;

lock table public.menu_categories, public.menu_items in share row exclusive mode;

delete from public.menu_items;
delete from public.menu_categories;

insert into public.menu_categories (id, name, sort_order) values
  ('printed-menu-01', 'FLAVOURS IN A BOWL', 1),
  ('printed-menu-02', 'THE SALAD EXPERIENCE', 2),
  ('printed-menu-03', 'FLAVOURS OF THE GARDEN- VEG', 3),
  ('printed-menu-04', 'NON-VEG BITES', 4),
  ('printed-menu-05', 'INDIAN BREAD SELECTION', 5),
  ('printed-menu-06', 'SIGNATURE RICE CREATIONS', 6),
  ('printed-menu-07', 'SPICE GARDEN BIRYANI SPECIALS', 7),
  ('printed-menu-08', 'FROM THE WOK', 8),
  ('printed-menu-09', 'GARDEN HARVEST SPECIALS', 9),
  ('printed-menu-10', 'SPICE GARDEN NON-VEG COLLECTION', 10),
  ('printed-menu-11', 'THE LASTING SWEET IMPRESSION', 11),
  ('printed-menu-12', 'YOUNG FOODIES CORNER', 12),
  ('printed-menu-13', 'FLAVOURS IN A GLASS', 13),
  ('printed-menu-14', 'ADDITIONAL MENU ITEMS (REPEATED IN SUPPLIED DETAILS)', 14),
  ('printed-menu-15', 'QUICK BITE', 15);

insert into public.menu_items (category, name, description, diet, price_paise, published, sort_order) values
  ('printed-menu-01', 'THAI CHICKEN SOUP', 'A comforting Thai-inspired chicken soup with fragrant herbs and warming flavours.', 'non-veg', 35000, true, 1),
  ('printed-menu-01', 'TOM YUM SOUP (PRAWNS)', 'A lively Thai-style soup with prawns, tangy citrus notes and a gentle chilli kick.', 'non-veg', 39000, true, 2),
  ('printed-menu-01', 'PUMPKIN SOUP (VEG)', 'A smooth, gently seasoned pumpkin soup with a naturally sweet and comforting taste.', 'veg', 25000, true, 3),
  ('printed-menu-01', 'GINGER CARROT SOUP (VEG)', 'A warming carrot soup brightened with the fresh, aromatic flavour of ginger.', 'veg', 25000, true, 4),
  ('printed-menu-01', 'CREAM OF BROCCOLI SOUP (VEG)', 'A velvety broccoli soup with a mild, creamy finish.', 'veg', 30000, true, 5),
  ('printed-menu-01', 'SEAFOOD SOUP', 'A flavourful soup prepared with seafood and a savoury, aromatic broth.', 'non-veg', 35000, true, 6),
  ('printed-menu-01', 'HOT & SOUR CHICKEN / VEG SOUP', 'A tangy, gently spicy soup with chicken and a satisfying savoury finish.

A tangy, gently spicy vegetable soup with a balanced savoury flavour.', 'non-veg', 25000, true, 7),
  ('printed-menu-01', 'VEG MANCHOW / CHICKEN', 'A hearty Indo-Chinese vegetable soup with garlic, ginger and a spicy finish.

A hearty Indo-Chinese soup with chicken, vegetables and bold savoury flavours.', 'non-veg', 25000, true, 8),
  ('printed-menu-01', 'VEG CLEAR / CHICKEN', 'A light, clear broth with vegetables and delicate seasoning.

A light chicken broth with gentle seasoning and a clean, comforting taste.', 'non-veg', 20000, true, 9),
  ('printed-menu-01', 'SWEET CORN VEG / CHICKEN', 'A mildly sweet, comforting soup with tender vegetables and sweet corn.

A comforting sweet corn soup with chicken and a gently savoury flavour.', 'non-veg', 25000, true, 10),
  ('printed-menu-01', 'CREAM TOMATO SOUP', 'A smooth tomato soup with a creamy texture and gently balanced seasoning.', 'veg', 20000, true, 11),
  ('printed-menu-01', 'CREAM OF VEG / CHICKEN', 'A creamy soup made with vegetables for a smooth and comforting bowl.

A rich, smooth chicken soup with a creamy finish.', 'non-veg', 25000, true, 12),
  ('printed-menu-01', 'LEMON CORIANDER VEG / CHICKEN', 'A refreshing vegetable soup with bright lemon and fragrant coriander.

A light chicken soup lifted with fresh lemon and aromatic coriander.', 'non-veg', 25000, true, 13),
  ('printed-menu-02', 'TOSSED SALAD - VEG / CHICKEN', 'A fresh mix of vegetables lightly tossed for a crisp, refreshing side.

A crisp tossed salad complemented with chicken for a more filling option.', 'non-veg', 25000, true, 14),
  ('printed-menu-02', 'HAWAIIAN SALAD - VEG / CHICKEN', 'A colourful salad combining fresh ingredients with a sweet, tropical touch.

A tropical-style salad with chicken and a refreshing sweet-and-savoury balance.', 'non-veg', 25000, true, 15),
  ('printed-menu-02', 'GARDEN FRESH GREEN SALAD', 'A simple, refreshing selection of fresh green vegetables.', 'veg', 22000, true, 16),
  ('printed-menu-02', 'WINTER SALAD', 'A seasonal-style salad featuring a variety of fresh, crisp ingredients.', 'veg', 25000, true, 17),
  ('printed-menu-02', 'ALOO CHAAT SALAD', 'Potato tossed with chaat-style spices for a tangy, savoury snack.', 'veg', 20000, true, 18),
  ('printed-menu-02', 'FRUIT CHAAT SALAD', 'A refreshing assortment of fruits with a lively chaat-style flavour.', 'veg', 25000, true, 19),
  ('printed-menu-02', 'GREEK SALAD', 'A fresh Mediterranean-style salad with crisp vegetables and a bright dressing.', 'veg', 20000, true, 20),
  ('printed-menu-02', 'GUJARATI KACHUMBER SALAD', 'A refreshing chopped salad of vegetables with a light, tangy seasoning.', 'veg', 20000, true, 21),
  ('printed-menu-02', 'GUJARATI CUCUMBER RAITA', 'Cooling cucumber mixed with seasoned yoghurt for a refreshing accompaniment.', 'veg', 20000, true, 22),
  ('printed-menu-03', 'CRISPY FRIED POTATO', 'Potato pieces fried until crisp and lightly seasoned.', 'veg', 30000, true, 23),
  ('printed-menu-03', 'HONEY CHILLI POTATO', 'Crispy potato tossed in a sweet, spicy and tangy honey-chilli glaze.', 'veg', 30000, true, 24),
  ('printed-menu-03', 'CRISPY FRIED VEGETABLES', 'A selection of vegetables coated and fried until golden and crunchy.', 'veg', 30000, true, 25),
  ('printed-menu-03', 'CHILLI PANEER', 'Paneer tossed with peppers, onion and a bold chilli-seasoned sauce.', 'veg', 35000, true, 26),
  ('printed-menu-03', 'HONEY CHILLI PANEER', 'Paneer pieces coated in a sweet-and-spicy honey chilli sauce.', 'veg', 35000, true, 27),
  ('printed-menu-03', 'CHILLI MUSHROOM', 'Mushrooms tossed with peppers and a lively chilli sauce.', 'veg', 35000, true, 28),
  ('printed-menu-03', 'CHILLI BABY CORN', 'Tender baby corn tossed in a spicy Indo-Chinese sauce.', 'veg', 35000, true, 29),
  ('printed-menu-03', 'CHILLI POTATO', 'Crispy potato tossed with chilli, peppers and savoury seasoning.', 'veg', 30000, true, 30),
  ('printed-menu-03', 'DRAGON PANEER', 'Paneer tossed in a bold, spicy sauce with an Indo-Chinese flavour.', 'veg', 35000, true, 31),
  ('printed-menu-03', 'DRAGON GOBI', 'Cauliflower florets coated and tossed in a punchy, spicy sauce.', 'veg', 30000, true, 32),
  ('printed-menu-03', 'PANEER TIKKA', 'Paneer pieces marinated with spices and cooked until lightly charred.', 'veg', 35000, true, 33),
  ('printed-menu-03', 'CHILLI GOBI', 'Cauliflower florets tossed with peppers and a spicy chilli sauce.', 'veg', 30000, true, 34),
  ('printed-menu-03', 'SESAME CAULIFLOWER', 'Crispy cauliflower finished with a savoury sesame-flavoured coating.', 'veg', 30000, true, 35),
  ('printed-menu-03', 'PEANUT MASALA', 'Peanuts tossed with spices and seasonings for a crunchy savoury bite.', 'veg', 25000, true, 36),
  ('printed-menu-03', 'ROASTED PAPAD', 'A thin, crisp papad roasted until light and crunchy.', 'veg', 10000, true, 37),
  ('printed-menu-03', 'MASALA PAPAD', 'Crisp papad topped with a tangy, spiced vegetable mixture.', 'veg', 20000, true, 38),
  ('printed-menu-03', 'TEMPURA FRIED VEG', 'Vegetables dipped in a light batter and fried until crisp.', 'veg', 30000, true, 39),
  ('printed-menu-03', 'CRISPY CORN CHAAT', 'Crunchy corn tossed with tangy spices for a lively chaat-style snack.', 'veg', 30000, true, 40),
  ('printed-menu-03', 'METHI NA GOTA', 'Gujarati-style fenugreek fritters with a savoury, spiced flavour.', 'veg', 25000, true, 41),
  ('printed-menu-04', 'CHICKEN 65', 'Bite-sized chicken pieces fried with a bold blend of spices and curry leaves.', 'non-veg', 45000, true, 42),
  ('printed-menu-04', 'KERALA CHICKEN FRY', 'Chicken cooked and fried with traditional Kerala spices for a rich, aromatic taste.', 'non-veg', 50000, true, 43),
  ('printed-menu-04', 'KERALA FISH FRY', 'Fish seasoned with Kerala-style spices and fried; availability and price are seasonal.', 'non-veg', null, true, 44),
  ('printed-menu-04', 'FISH POLLICHATHU', 'Fish prepared in a traditional Kerala-style spiced preparation; listed at seasonal/market rate.', 'non-veg', null, true, 45),
  ('printed-menu-04', 'CHILLI CHICKEN', 'Chicken tossed with peppers, onion and a spicy Indo-Chinese sauce.', 'non-veg', 48000, true, 46),
  ('printed-menu-04', 'CHILLI FISH', 'Fish pieces tossed in a spicy chilli sauce with savoury seasoning.', 'non-veg', 42000, true, 47),
  ('printed-menu-04', 'CHILLI PRAWNS', 'Prawns tossed with chilli, peppers and a bold savoury sauce.', 'non-veg', 60000, true, 48),
  ('printed-menu-04', 'GINGER PRAWNS', 'Prawns cooked with aromatic ginger and complementary seasoning.', 'non-veg', 60000, true, 49),
  ('printed-menu-04', 'CHICKEN OYSTER SAUCE', 'Chicken cooked in a savoury oyster-style sauce.', 'non-veg', 40000, true, 51),
  ('printed-menu-04', 'FISH OYSTER SAUCE', 'Fish prepared with a rich, savoury oyster-style sauce.', 'non-veg', 49000, true, 52),
  ('printed-menu-04', 'DRAGON CHICKEN', 'Crispy chicken tossed in a bold, spicy Indo-Chinese sauce.', 'non-veg', 45000, true, 53),
  ('printed-menu-04', 'LEMON CORIANDER CHICKEN', 'Chicken flavoured with fresh lemon and fragrant coriander.', 'non-veg', 45000, true, 54),
  ('printed-menu-04', 'SESAME CHICKEN', 'Chicken coated in a savoury sauce and finished with sesame.', 'non-veg', 45000, true, 55),
  ('printed-menu-04', 'HONEY CHILLI CHICKEN', 'Chicken tossed in a sweet, spicy honey-chilli glaze.', 'non-veg', 45000, true, 56),
  ('printed-menu-04', 'CHICKEN MANCHURIAN', 'Chicken pieces tossed in a tangy, savoury Manchurian-style sauce.', 'non-veg', 45000, true, 57),
  ('printed-menu-04', 'EGG MANCHURIAN', 'Egg prepared in a tangy Indo-Chinese Manchurian-style sauce.', 'non-veg', 35000, true, 58),
  ('printed-menu-04', 'GINGER CHICKEN WITH HONEY', 'Chicken cooked with aromatic ginger and a touch of honey.', 'non-veg', 40000, true, 59),
  ('printed-menu-04', 'SCHEZWAN CHICKEN', 'Chicken tossed in a bold, spicy Schezwan-style sauce.', 'non-veg', 45000, true, 60),
  ('printed-menu-04', 'PEPPER CHICKEN', 'Chicken cooked with aromatic pepper and savoury spices.', 'non-veg', 40000, true, 61),
  ('printed-menu-04', 'CHICKEN KONDATTAM', 'A Kerala-style chicken preparation with a bold, spicy seasoning.', 'non-veg', 45000, true, 62),
  ('printed-menu-04', 'SQUID ULARTHIYATHU', 'Squid stir-fried Kerala-style with aromatic spices; availability and price are seasonal.', 'non-veg', null, true, 63),
  ('printed-menu-04', 'PRAWNS TAWA FRY', 'Prawns cooked on a hot griddle with a flavourful spice coating.', 'non-veg', 60000, true, 64),
  ('printed-menu-04', 'GOLDEN FRIED PRAWNS', 'Prawns coated and fried until crisp and golden.', 'non-veg', 65000, true, 65),
  ('printed-menu-04', 'TEMPURA FRIED PRAWNS', 'Prawns dipped in a light tempura batter and fried until crisp.', 'non-veg', 65000, true, 66),
  ('printed-menu-04', 'PRAWNS GREEN CHILLI TAWA', 'Prawns cooked on a hot griddle with green chilli and aromatic seasoning.', 'non-veg', 60000, true, 67),
  ('printed-menu-04', 'FISH AMRITSARI', 'Fish pieces coated in a spiced batter and fried in Amritsari style.', 'non-veg', 55000, true, 68),
  ('printed-menu-04', 'FISH PEPPER FRY', 'Fish cooked or fried with aromatic pepper and savoury spices.', 'non-veg', 60000, true, 69),
  ('printed-menu-05', 'BREAD BASKET (BUTTER NAAN, GARLIC NAAN, KULCHA, TAWA ROTI, LACHA PARATHA)', 'A selection of butter naan, garlic naan, kulcha, tawa roti and lacha paratha.', 'veg', 29000, true, 70),
  ('printed-menu-05', 'CHAPPATHI', 'Soft, round whole-wheat flatbread cooked on a hot griddle.', 'veg', 4500, true, 71),
  ('printed-menu-05', 'BUTTER CHAPPATHI', 'Whole-wheat chappathi finished with a layer of butter.', 'veg', 5500, true, 72),
  ('printed-menu-05', 'PHULKA (2 PC)', 'Two light, puffed whole-wheat flatbreads.', 'veg', 3500, true, 73),
  ('printed-menu-05', 'NAAN', 'Soft, leavened Indian flatbread traditionally baked in a hot oven.', 'veg', 10000, true, 74),
  ('printed-menu-05', 'BUTTER NAAN', 'Soft naan finished with butter for a rich, tender taste.', 'veg', 12000, true, 75),
  ('printed-menu-05', 'GARLIC NAAN', 'Naan topped with fragrant garlic for a savoury finish.', 'veg', 13000, true, 76),
  ('printed-menu-05', 'TAWA ROTI', 'Whole-wheat flatbread cooked on a traditional griddle.', 'veg', 7500, true, 77),
  ('printed-menu-05', 'KULCHA', 'A soft, leavened Indian flatbread with a tender texture.', 'veg', 10000, true, 78),
  ('printed-menu-05', 'MASALA KULCHA', 'Kulcha seasoned with a savoury blend of spices.', 'veg', 12000, true, 79),
  ('printed-menu-05', 'LACHA PARATHA', 'A flaky, layered Indian flatbread with a crisp exterior.', 'veg', 11000, true, 80),
  ('printed-menu-05', 'ALOO PARATHA', 'Whole-wheat flatbread stuffed with a spiced potato filling.', 'veg', 20000, true, 81),
  ('printed-menu-05', 'TAWA PARATHA', 'Layered flatbread cooked on a hot griddle until golden.', 'veg', 10000, true, 82),
  ('printed-menu-05', 'KASHMIRI NAAN', 'A sweet-style naan with a rich, fruit-and-nut-inspired filling.', 'veg', 15000, true, 83),
  ('printed-menu-06', 'TAMARIND RICE', 'Rice tossed with tangy tamarind and aromatic spices.', 'veg', 27500, true, 84),
  ('printed-menu-06', 'STEAMED RICE', 'Plain rice steamed until fluffy and tender.', 'veg', 22000, true, 85),
  ('printed-menu-06', 'JEERA RICE', 'Fragrant rice tempered with cumin for a warm, aromatic flavour.', 'veg', 30000, true, 86),
  ('printed-menu-06', 'GHEE RICE', 'Rice cooked with ghee and delicate aromatic spices.', 'veg', 32000, true, 87),
  ('printed-menu-06', 'LEMON RICE', 'Rice flavoured with lemon and a light tempering of spices.', 'veg', 30000, true, 88),
  ('printed-menu-06', 'TOMATO RICE', 'Rice cooked with tomatoes and a savoury blend of spices.', 'veg', 30000, true, 89),
  ('printed-menu-06', 'VEG PULAO', 'Fragrant rice cooked with mixed vegetables and mild spices.', 'veg', 35000, true, 90),
  ('printed-menu-06', 'PEAS PULAO', 'Aromatic rice prepared with green peas and gentle seasoning.', 'veg', 35000, true, 91),
  ('printed-menu-06', 'KASHMIRI PULAO', 'Mildly sweet, fragrant rice with a Kashmiri-inspired fruit-and-nut touch.', 'veg', 38000, true, 92),
  ('printed-menu-06', 'CURD RICE', 'Soft rice blended with cooling yoghurt and mild seasoning.', 'veg', 27000, true, 93),
  ('printed-menu-06', 'VEG KHICHDI', 'A comforting one-pot preparation of rice, lentils and vegetables.', 'veg', 27000, true, 94),
  ('printed-menu-06', 'VEG MASALA BHAAT', 'Rice cooked with vegetables and a flavourful masala blend.', 'veg', 38000, true, 95),
  ('printed-menu-06', 'PUDINA RICE', 'Fragrant rice flavoured with fresh mint and spices.', 'veg', 30000, true, 96),
  ('printed-menu-06', 'NUTTY PULAO', 'Aromatic pulao with a nutty touch and gentle seasoning.', 'veg', 35000, true, 97),
  ('printed-menu-06', 'PINEAPPLE PULAO', 'Fragrant rice with a delicate sweet-and-savoury pineapple flavour.', 'veg', 35000, true, 98),
  ('printed-menu-07', 'VEG BIRYANI', 'Fragrant basmati-style rice layered with vegetables and aromatic biryani spices.', 'veg', 39000, true, 99),
  ('printed-menu-07', 'KERALA CHICKEN DUM BIRYANI (PRE-ORDER MIN. 6 PORTION)', 'Chicken and aromatic rice cooked together in dum style with traditional Kerala flavours. Pre-order required; minimum 6 portions.', 'non-veg', 52000, true, 100),
  ('printed-menu-07', 'NORTH INDIAN STYLE CHICKEN BIRYANI', 'Aromatic rice cooked with chicken and a rich North Indian-style spice blend.', 'non-veg', 50000, true, 101),
  ('printed-menu-07', 'FISH BIRYANI', 'Fragrant biryani rice paired with fish and a savoury blend of spices.', 'non-veg', 60000, true, 102),
  ('printed-menu-07', 'PRAWNS BIRYANI', 'Aromatic biryani rice prepared with prawns and flavourful spices.', 'non-veg', 75000, true, 103),
  ('printed-menu-08', 'VEG FRIED RICE', 'Wok-tossed rice with vegetables and savoury seasoning.', 'veg', 30000, true, 104),
  ('printed-menu-08', 'SCHEZWAN VEG FRIED RICE', 'Wok-tossed vegetable rice with a bold, spicy Schezwan flavour.', 'veg', 32000, true, 105),
  ('printed-menu-08', 'CHICKEN FRIED RICE', 'Wok-tossed rice with chicken, vegetables and savoury seasoning.', 'non-veg', 39000, true, 106),
  ('printed-menu-08', 'SCHEZWAN CHICKEN FRIED RICE', 'Chicken fried rice tossed with a spicy Schezwan-style sauce.', 'non-veg', 39000, true, 107),
  ('printed-menu-08', 'PRAWNS FRIED RICE', 'Wok-tossed rice with prawns and aromatic savoury seasoning.', 'non-veg', 58000, true, 108),
  ('printed-menu-08', 'MIXED FRIED RICE', 'A wok-fried combination of rice and mixed ingredients.', 'non-veg', 59000, true, 109),
  ('printed-menu-08', 'EGG FRIED RICE', 'Wok-tossed rice with egg and savoury seasoning.', 'non-veg', 34000, true, 110),
  ('printed-menu-08', 'SCHEZWAN EGG FRIED RICE', 'Egg fried rice with a bold, spicy Schezwan-style flavour.', 'non-veg', 34000, true, 111),
  ('printed-menu-08', 'SINGAPORE FRIED RICE', 'Wok-tossed rice prepared in a Singapore-style seasoning.', 'unknown', 37000, false, 112),
  ('printed-menu-08', 'VEG HAKKA NOODLES', 'Stir-fried noodles tossed with vegetables and classic Hakka-style seasoning.', 'veg', 32000, true, 113),
  ('printed-menu-08', 'CHICKEN HAKKA NOODLES', 'Stir-fried noodles with chicken and savoury Hakka-style seasoning.', 'non-veg', 38000, true, 114),
  ('printed-menu-08', 'SCHEZWAN VEG NOODLES', 'Vegetable noodles tossed in a spicy Schezwan-style sauce.', 'veg', 32000, true, 115),
  ('printed-menu-08', 'SCHEZWAN CHICKEN NOODLES', 'Chicken noodles tossed in a bold, spicy Schezwan-style sauce.', 'non-veg', 38000, true, 116),
  ('printed-menu-08', 'EGG NOODLES', 'Stir-fried noodles with egg and savoury seasoning.', 'non-veg', 32000, true, 117),
  ('printed-menu-08', 'MIXED NOODLES', 'Stir-fried noodles prepared with a combination of ingredients.', 'non-veg', 49000, true, 118),
  ('printed-menu-08', 'PRAWN NOODLES', 'Wok-tossed noodles with prawns and savoury seasoning.', 'non-veg', 59000, true, 119),
  ('printed-menu-08', 'SINGAPORE NOODLES VEG / CHICKEN', 'Noodles tossed with vegetables in a Singapore-style seasoning.

Noodles tossed with chicken in a Singapore-style seasoning.', 'non-veg', 39000, true, 120),
  ('printed-menu-08', 'SINGAPORE FRIED NOODLES VEG / CHICKEN', 'Fried noodles with vegetables and Singapore-style seasoning.

Fried noodles with chicken and Singapore-style seasoning.', 'non-veg', 39000, true, 121),
  ('printed-menu-08', 'ADS SPECIAL TRIPLE FRIED NOODLES VEG / CHICKEN', 'A special triple-style fried noodle preparation with vegetables.

A special triple-style fried noodle preparation with chicken.', 'non-veg', 45000, true, 122),
  ('printed-menu-09', 'DAL FRY', 'Lentils cooked with a savoury tempering of spices.', 'veg', 26000, true, 123),
  ('printed-menu-09', 'DAL TADKA / LASOONI / MAKHANI / PALAK / HARA PYAAZ', 'Yellow lentils finished with a fragrant tempering of spices.

Lentils flavoured with aromatic garlic.

Slow-style black lentils in a rich, creamy preparation.

Lentils cooked with spinach for a comforting, savoury curry.

Lentils prepared with fresh spring onion and seasoning.', 'veg', 28000, true, 124),
  ('printed-menu-09', 'ALOO MUTTER', 'Potatoes and green peas simmered in a spiced curry.', 'veg', 25000, true, 125),
  ('printed-menu-09', 'ALOO SHIMLA MIRCH', 'Potatoes and capsicum cooked together with aromatic spices.', 'veg', 25000, true, 126),
  ('printed-menu-09', 'ALOO GOBI / JEERA / BHINDI / BAINGAN', 'Potatoes and cauliflower cooked in a traditional spiced preparation.

Potatoes tossed with cumin and savoury spices.

Potatoes and okra cooked with a flavourful masala.

Potatoes and eggplant simmered with aromatic spices.', 'veg', 25000, true, 127),
  ('printed-menu-09', 'BAINGAN MASALA', 'Eggplant cooked in a rich, spiced masala gravy.', 'veg', 25000, true, 128),
  ('printed-menu-09', 'BHINDI MASALA', 'Okra cooked with onions, tomatoes and savoury spices.', 'veg', 25000, true, 129),
  ('printed-menu-09', 'BHINDI JAIPURI', 'Okra prepared in a Jaipuri-style spiced masala.', 'veg', 25000, true, 130),
  ('printed-menu-09', 'GOBI SHIMLA MIRCH', 'Cauliflower and capsicum cooked with aromatic seasoning.', 'veg', 25000, true, 131),
  ('printed-menu-09', 'MIX VEG CURRY', 'A medley of vegetables simmered in a flavourful curry.', 'veg', 25000, true, 132),
  ('printed-menu-09', 'PANEER BUTTER MASALA', 'Paneer cubes simmered in a rich, creamy tomato-and-butter gravy.', 'veg', 35000, true, 133),
  ('printed-menu-09', 'PANEER SHIMLA', 'Paneer cooked with capsicum in a savoury masala.', 'veg', 36000, true, 134),
  ('printed-menu-09', 'PANEER DO PYAZA', 'Paneer prepared with generous onion and a spiced gravy.', 'veg', 36000, true, 135),
  ('printed-menu-09', 'PANEER LABABDAR', 'Paneer simmered in a rich, creamy and mildly spiced gravy.', 'veg', 36000, true, 136),
  ('printed-menu-09', 'METHI PANEER', 'Paneer cooked with fenugreek leaves in a savoury gravy.', 'veg', 36000, true, 137),
  ('printed-menu-09', 'SHAHI PANEER', 'Paneer in a rich, mildly spiced and creamy royal-style gravy.', 'veg', 36000, true, 138),
  ('printed-menu-09', 'KADAI PANEER', 'Paneer and capsicum tossed in a bold kadai masala.', 'veg', 39000, true, 139),
  ('printed-menu-09', 'KADAI GOBI', 'Cauliflower cooked with capsicum and aromatic kadai spices.', 'veg', 35000, true, 140),
  ('printed-menu-09', 'CORN CAPSICUM MASALA', 'Sweet corn and capsicum cooked in a flavourful masala gravy.', 'veg', 35000, true, 141),
  ('printed-menu-09', 'MUSHROOM MASALA', 'Mushrooms simmered in a savoury spiced gravy.', 'veg', 35000, true, 142),
  ('printed-menu-09', 'DHINGRI MUTTER', 'Mushrooms and green peas cooked together in a rich masala.', 'veg', 35000, true, 143),
  ('printed-menu-09', 'VEG KURMA', 'Mixed vegetables simmered in a mildly spiced kurma-style gravy.', 'veg', 22000, true, 144),
  ('printed-menu-09', 'PANEER KHURCHAN', 'Paneer cooked with sliced vegetables and a rich, savoury masala.', 'veg', 38000, true, 145),
  ('printed-menu-09', 'PANEER TIKKA MASALA', 'Tandoor-style spiced paneer served in a flavourful masala gravy.', 'veg', 36000, true, 146),
  ('printed-menu-10', 'KADAI CHICKEN', 'Chicken cooked with capsicum and a robust kadai spice blend.', 'non-veg', 42000, true, 147),
  ('printed-menu-10', 'CHICKEN MASALA', 'Chicken simmered in a traditional onion-and-tomato masala gravy.', 'non-veg', 42000, true, 148),
  ('printed-menu-10', 'BUTTER CHICKEN MASALA', 'Tender chicken in a rich, creamy tomato-and-butter gravy.', 'non-veg', 45000, true, 149),
  ('printed-menu-10', 'CHICKEN LAHORI', 'Chicken prepared in a rich, aromatic Lahori-style gravy.', 'non-veg', 42000, true, 150),
  ('printed-menu-10', 'CHICKEN KURMA', 'Chicken simmered in a mildly spiced, creamy kurma-style gravy.', 'non-veg', 42000, true, 151),
  ('printed-menu-10', 'CHICKEN TAWA FRY', 'Chicken cooked on a hot griddle with aromatic spices.', 'non-veg', 48000, true, 152),
  ('printed-menu-10', 'KERALA CHICKEN CURRY', 'Chicken simmered in a traditional Kerala-style spiced curry.', 'non-veg', 45000, true, 153),
  ('printed-menu-10', 'KOVALAM CHICKEN VARUTHARACHATHU', 'Chicken cooked in a Kerala-style roasted coconut and spice gravy.', 'non-veg', 48000, true, 154),
  ('printed-menu-10', 'KOVALAM PRAWNS MASALA', 'Prawns simmered in a flavourful coastal-style masala.', 'non-veg', 59000, true, 155),
  ('printed-menu-10', 'KOVALAM PRAWNS CURRY', 'Prawns cooked in a savoury coastal-style curry.', 'non-veg', 56000, true, 156),
  ('printed-menu-10', 'PRAWNS BUTTER GARLIC', 'Prawns tossed with butter and fragrant garlic.', 'non-veg', 61000, true, 157),
  ('printed-menu-10', 'KADAI JHINGA', 'Prawns cooked with capsicum and a bold kadai masala.', 'non-veg', 59000, true, 158),
  ('printed-menu-10', 'KOVALAM FISH MASALA', 'Fish simmered in a richly seasoned coastal-style masala.', 'non-veg', 51000, true, 159),
  ('printed-menu-10', 'KOVALAM FISH ROAST', 'Fish prepared with a robust, aromatic coastal-style roast masala.', 'non-veg', 54000, true, 160),
  ('printed-menu-10', 'CHEF SPECIAL (KERALA FISH CURRY)', 'A chef-selected Kerala-style fish curry with traditional spices.', 'non-veg', 55000, true, 161),
  ('printed-menu-10', 'EGG CURRY', 'Eggs simmered in a savoury spiced curry gravy.', 'non-veg', 25000, true, 162),
  ('printed-menu-10', 'EGG MASALA', 'Eggs cooked in a rich onion-and-tomato masala.', 'non-veg', 28000, true, 163),
  ('printed-menu-10', 'EGG ROAST', 'Eggs coated in a roasted onion masala with aromatic spices.', 'non-veg', 28000, true, 164),
  ('printed-menu-10', 'KERALA PRAWNS GHEE ROAST', 'Prawns coated in a bold Kerala-style roasted spice masala with ghee.', 'non-veg', 66000, true, 165),
  ('printed-menu-10', 'KERALA PAAL KONJU (ADD PRAWNS) (PHOTO)', 'A Kerala-style milk-based prawn preparation with a rich, savoury character.', 'non-veg', 66000, true, 166),
  ('printed-menu-11', 'BANANA SPLIT', 'A classic dessert of banana served with ice cream and sweet toppings.', 'veg', 39000, true, 167),
  ('printed-menu-11', 'FRIED ICE CREAM', 'Ice cream wrapped in a crisp coating for a contrast of warm crunch and cold centre.', 'veg', 42000, true, 168),
  ('printed-menu-11', 'SUJI KHEER', 'A smooth, sweet pudding prepared with semolina and milk.', 'veg', 24000, true, 170),
  ('printed-menu-11', 'SWEET POHA', 'Flattened rice prepared as a lightly sweetened traditional dessert.', 'veg', 22000, true, 171),
  ('printed-menu-11', 'BANANA WITH HONEY NUTS', 'Banana served with honey and a crunchy nut topping.', 'veg', 27500, true, 172),
  ('printed-menu-11', 'FRUIT CREAM', 'A chilled dessert of mixed fruits folded into sweet cream.', 'veg', 34000, true, 173),
  ('printed-menu-11', 'BANANA FRITTERS WITH VANILLA ICE CREAM', 'Golden banana fritters served with vanilla ice cream.', 'veg', 36000, true, 174),
  ('printed-menu-11', 'COCONUT JAGGERY BALL', 'A sweet bite made with coconut and jaggery.', 'veg', 28000, true, 175),
  ('printed-menu-11', 'BROWNIE WITH VANILLA ICE CREAM', 'A chocolate brownie served with cool vanilla ice cream.', 'veg', 35000, true, 176),
  ('printed-menu-11', 'GULAB JAMUN WITH ICE CREAM', 'Soft gulab jamun paired with a scoop of ice cream.', 'veg', 35000, true, 177),
  ('printed-menu-11', 'RICE KHEER', 'A traditional creamy rice pudding gently sweetened and flavoured.', 'veg', 25000, true, 178),
  ('printed-menu-11', 'KERALA PAYASAM', 'A traditional Kerala-style sweet pudding served as a dessert.', 'veg', 29000, true, 179),
  ('printed-menu-11', 'CHOICE OF ICE CREAM (2 SCOOPS)', 'Two scoops of ice cream in your choice of available flavour.', 'veg', 19000, true, 180),
  ('printed-menu-11', 'FRUIT PLATTER', 'A selection of fresh seasonal fruits served together.', 'veg', 29000, true, 181),
  ('printed-menu-11', 'FRUIT SALAD WITH ICE CREAM', 'A refreshing mix of fruits served with ice cream.', 'veg', 30000, true, 182),
  ('printed-menu-12', 'LOADED FRIES', 'Crispy fries topped with a generous mix of savoury toppings.', 'unknown', 45000, false, 183),
  ('printed-menu-12', 'FRENCH FRIES', 'Classic potato fries cooked until golden and crisp.', 'veg', 18000, true, 184),
  ('printed-menu-12', 'GARDEN FRESH SANDWICH', 'A sandwich filled with fresh vegetables for a light, satisfying bite.', 'veg', 22500, true, 185),
  ('printed-menu-12', 'GARDEN FRESH CHEESE SANDWICH', 'Fresh vegetables and cheese layered between slices of bread.', 'veg', 26000, true, 186),
  ('printed-menu-12', 'CLASSIC EGG SANDWICH', 'A simple sandwich filled with egg and savoury seasoning.', 'non-veg', 18000, true, 187),
  ('printed-menu-12', 'SIGNATURE CHICKEN SANDWICH', 'A house-style sandwich filled with seasoned chicken.', 'non-veg', 31000, true, 188),
  ('printed-menu-12', 'SIGNATURE CHICKEN CHEESE SANDWICH', 'Seasoned chicken and cheese layered in a satisfying sandwich.', 'non-veg', 33000, true, 189),
  ('printed-menu-12', 'SIGNATURE CHEESE SANDWICH', 'A cheese-filled sandwich with a rich, savoury taste.', 'veg', 28000, true, 190),
  ('printed-menu-12', 'CHEESE CHERRY PINEAPPLE', 'A sweet-and-savoury combination of cheese, cherry and pineapple.', 'veg', 32000, true, 191),
  ('printed-menu-12', 'CHICKEN CLUB SANDWICH', 'A layered club sandwich with chicken and classic savoury fillings.', 'non-veg', 42000, true, 192),
  ('printed-menu-12', 'MAGGI VEG / CHICKEN', 'Instant noodles prepared with vegetables and seasoning.

Instant noodles prepared with chicken and savoury seasoning.', 'non-veg', 25000, true, 193),
  ('printed-menu-12', 'CHICKEN NUGGETS', 'Bite-sized chicken pieces coated and fried until golden.', 'non-veg', 25000, true, 194),
  ('printed-menu-13', 'MILK TEA', 'A comforting cup of tea blended with milk.', 'veg', 6500, true, 195),
  ('printed-menu-13', 'MILK COFFEE', 'Coffee prepared with milk for a smooth, mellow cup.', 'veg', 8000, true, 196),
  ('printed-menu-13', 'BLACK TEA', 'A simple cup of tea served without milk.', 'veg', 4500, true, 197),
  ('printed-menu-13', 'BLACK COFFEE', 'Coffee served without milk for a bold, clean flavour.', 'veg', 6000, true, 198),
  ('printed-menu-13', 'HOT MILK', 'A warm serving of milk.', 'veg', 8000, true, 199),
  ('printed-menu-13', 'MASALA TEA', 'Tea brewed with milk and aromatic spices.', 'veg', 8000, true, 200),
  ('printed-menu-13', 'GREEN TEA', 'A light, refreshing tea with a delicate flavour.', 'veg', 8000, true, 201),
  ('printed-menu-13', 'LEMON TEA', 'Tea brightened with a refreshing touch of lemon.', 'veg', 8000, true, 202),
  ('printed-menu-13', 'GINGER TEA', 'Tea infused with the warming flavour of ginger.', 'veg', 8000, true, 203),
  ('printed-menu-13', 'PEPPERMINT TEA', 'A refreshing herbal-style tea with a cool peppermint note.', 'veg', 8000, true, 204),
  ('printed-menu-13', 'MILKSHAKE (CHOCOLATE / VANILLA / STRAWBERRY)', 'A chilled, creamy milkshake with chocolate flavour.

A chilled, creamy milkshake with classic vanilla flavour.

A chilled, creamy milkshake with sweet strawberry flavour.', 'veg', 35000, true, 205),
  ('printed-menu-13', 'PINEAPPLE JUICE', 'A refreshing juice with the bright, tropical taste of pineapple.', 'veg', 22000, true, 206),
  ('printed-menu-13', 'CHOICE OF JUICE', 'A freshly served juice in your choice of available flavour.', 'veg', 24000, true, 207),
  ('printed-menu-13', 'LIME SODA', 'A refreshing lime drink topped with soda.', 'veg', 19000, true, 208),
  ('printed-menu-13', 'LIME JUICE', 'A refreshing drink made with fresh lime.', 'veg', 18000, true, 209),
  ('printed-menu-13', 'MINT LIME JUICE', 'Lime juice brightened with cool, refreshing mint.', 'veg', 18000, true, 210),
  ('printed-menu-13', 'MINT LIME SODA', 'A fizzy lime drink with a refreshing hint of mint.', 'veg', 18000, true, 211),
  ('printed-menu-13', 'LASSI (SWEET / SALT)', 'A chilled yoghurt-based drink with a sweet, creamy finish.

A chilled savoury yoghurt drink with a light, refreshing taste.', 'veg', 18000, true, 212),
  ('printed-menu-13', 'KERALA LASSI', 'A yoghurt-based drink served in a Kerala-inspired style.', 'veg', 12000, true, 213),
  ('printed-menu-13', 'SOFT DRINKS', 'A selection of chilled soft drinks.', 'veg', null, true, 214),
  ('printed-menu-13', 'SODA', 'Chilled soda water, served refreshing and fizzy.', 'veg', null, true, 215),
  ('printed-menu-14', 'KERALA CHEMMEEN VARUTHARACHA', 'Prawns prepared with a traditional Kerala roasted-spice flavour.', 'non-veg', 65000, true, 220),
  ('printed-menu-14', 'KARIMEEN POLLICHATHU (PEARL SPOT)', 'Pearl spot fish prepared in a traditional Kerala-style spiced preparation; seasonal availability.', 'non-veg', null, true, 221),
  ('printed-menu-14', 'FISH TAWA FRY', 'Fish seasoned and cooked on a hot griddle; seasonal availability.', 'non-veg', null, true, 222),
  ('printed-menu-15', 'VEG PAKORA', 'Vegetable pieces coated in spiced batter and fried until crisp.', 'veg', 22500, true, 223),
  ('printed-menu-15', 'CHICKEN PAKORA', 'Chicken pieces coated in seasoned batter and fried until golden.', 'non-veg', 32000, true, 224),
  ('printed-menu-15', 'PANEER PAKODA', 'Paneer pieces dipped in spiced batter and fried until crisp.', 'veg', 27500, true, 225),
  ('printed-menu-15', 'ONION PAKODA', 'Sliced onions coated in spiced batter and fried until crunchy.', 'veg', 22500, true, 226),
  ('printed-menu-15', 'BANANA FRITTERS (2 PIECES)', 'Two pieces of banana coated in batter and fried until golden.', 'veg', 15000, true, 228);

do $$
begin
  if (select count(*) from public.menu_categories) <> 15
    or (select count(*) from public.menu_items) <> 221 then
    raise exception 'Unexpected menu counts; replacement cancelled.';
  end if;
end $$;

commit;
