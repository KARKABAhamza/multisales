import 'package:flutter/foundation.dart';

/// Promotions Provider for MultiSales Client App
/// Handles promotions, offers, news feed, and marketing campaigns
class PromotionsProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _activePromotions = [];
  List<Map<String, dynamic>> _newsArticles = [];
  List<Map<String, dynamic>> _personalizedOffers = [];
  Map<String, bool> _subscribedCategories = {};
  final List<String> _appliedPromoCodes = [];

  String _selectedCategory = 'all';
  bool _showPersonalizedContent = true;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get activePromotions => _activePromotions;
  List<Map<String, dynamic>> get newsArticles => _newsArticles;
  List<Map<String, dynamic>> get personalizedOffers => _personalizedOffers;
  Map<String, bool> get subscribedCategories => _subscribedCategories;
  List<String> get appliedPromoCodes => _appliedPromoCodes;
  String get selectedCategory => _selectedCategory;
  bool get showPersonalizedContent => _showPersonalizedContent;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Initialize Promotions System
  Future<bool> initializePromotions(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 700));

      // Load promotions and news
      await Future.wait([
        _loadActivePromotions(),
        _loadNewsArticles(),
        _loadPersonalizedOffers(clientId),
        _loadSubscriptionPreferences(clientId),
      ]);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize promotions: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Active Promotions
  Future<bool> _loadActivePromotions() async {
    try {
      _activePromotions = [
        {
          'id': 'promo_001',
          'title': 'Summer Fiber Upgrade',
          'subtitle': '50% Off First 3 Months',
          'description':
              'Upgrade to our premium fiber internet plan and enjoy blazing fast speeds at half the price for your first 3 months.',
          'category': 'internet',
          'type': 'discount',
          'discountPercent': 50,
          'discountAmount': null,
          'originalPrice': 299.0,
          'discountedPrice': 149.5,
          'currency': 'MAD',
          'promoCode': 'SUMMER50',
          'validFrom': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'validUntil':
              DateTime.now().add(const Duration(days: 25)).toIso8601String(),
          'imageUrl': 'assets/images/promo_fiber_upgrade.jpg',
          'bannerColor': '#FF6B35',
          'isPersonalized': true,
          'targetAudience': ['existing_customers', 'internet_users'],
          'conditions': [
            'Valid for existing customers only',
            'Minimum 12-month commitment',
            'Cannot be combined with other offers',
            'Subject to availability in your area',
          ],
          'callToAction': 'Upgrade Now',
          'priority': 'high',
          'isActive': true,
          'clickCount': 0,
          'conversionCount': 0,
        },
        {
          'id': 'promo_002',
          'title': 'Mobile + Internet Bundle',
          'subtitle': 'Save 100 MAD Monthly',
          'description':
              'Combine your mobile and internet services and save 100 MAD every month with our exclusive bundle offer.',
          'category': 'bundle',
          'type': 'fixed_discount',
          'discountPercent': null,
          'discountAmount': 100.0,
          'originalPrice': 449.0,
          'discountedPrice': 349.0,
          'currency': 'MAD',
          'promoCode': 'BUNDLE100',
          'validFrom': DateTime.now()
              .subtract(const Duration(days: 10))
              .toIso8601String(),
          'validUntil':
              DateTime.now().add(const Duration(days: 45)).toIso8601String(),
          'imageUrl': 'assets/images/promo_mobile_bundle.jpg',
          'bannerColor': '#4ECDC4',
          'isPersonalized': false,
          'targetAudience': ['new_customers', 'mobile_users'],
          'conditions': [
            'Available for new customers',
            'Requires both mobile and internet subscription',
            'Minimum 24-month commitment',
            'Installation fees may apply',
          ],
          'callToAction': 'Get Bundle',
          'priority': 'medium',
          'isActive': true,
          'clickCount': 0,
          'conversionCount': 0,
        },
        {
          'id': 'promo_003',
          'title': 'Free Installation Week',
          'subtitle': 'Zero Installation Fees',
          'description':
              'Subscribe to any of our services this week and get completely free professional installation worth 200 MAD.',
          'category': 'installation',
          'type': 'free_service',
          'discountPercent': null,
          'discountAmount': 200.0,
          'originalPrice': 200.0,
          'discountedPrice': 0.0,
          'currency': 'MAD',
          'promoCode': 'FREEINSTALL',
          'validFrom': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'validUntil':
              DateTime.now().add(const Duration(days: 5)).toIso8601String(),
          'imageUrl': 'assets/images/promo_free_installation.jpg',
          'bannerColor': '#45B7D1',
          'isPersonalized': false,
          'targetAudience': ['new_customers', 'all_users'],
          'conditions': [
            'Valid for new service subscriptions only',
            'Professional installation included',
            'Valid in Casablanca, Rabat, and Marrakech',
            'Appointment required',
          ],
          'callToAction': 'Book Now',
          'priority': 'urgent',
          'isActive': true,
          'clickCount': 0,
          'conversionCount': 0,
        },
        {
          'id': 'promo_004',
          'title': 'Student Discount Program',
          'subtitle': '30% Off All Plans',
          'description':
              'Students get 30% discount on all internet and mobile plans. Valid with student ID verification.',
          'category': 'student',
          'type': 'discount',
          'discountPercent': 30,
          'discountAmount': null,
          'originalPrice': null,
          'discountedPrice': null,
          'currency': 'MAD',
          'promoCode': 'STUDENT30',
          'validFrom': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
          'validUntil':
              DateTime.now().add(const Duration(days: 90)).toIso8601String(),
          'imageUrl': 'assets/images/promo_student_discount.jpg',
          'bannerColor': '#96CEB4',
          'isPersonalized': false,
          'targetAudience': ['students', 'young_adults'],
          'conditions': [
            'Valid student ID required',
            'Age limit: 18-26 years',
            'Cannot be combined with family plans',
            'Verification required for activation',
          ],
          'callToAction': 'Verify & Apply',
          'priority': 'low',
          'isActive': true,
          'clickCount': 0,
          'conversionCount': 0,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load promotions: $e');
      return false;
    }
  }

  // Load News Articles
  Future<bool> _loadNewsArticles() async {
    try {
      _newsArticles = [
        {
          'id': 'news_001',
          'title': 'MultiSales Expands Fiber Network to 50 New Cities',
          'subtitle': 'High-speed internet now available in rural areas',
          'category': 'company_news',
          'publishedDate': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'author': 'MultiSales Communications Team',
          'imageUrl': 'assets/images/news_fiber_expansion.jpg',
          'content':
              'MultiSales is proud to announce the expansion of our fiber-optic network to 50 additional cities across Morocco, bringing high-speed internet access to rural and underserved communities...',
          'summary':
              'Major infrastructure expansion brings fiber internet to rural Morocco.',
          'readTime': 3, // minutes
          'tags': ['fiber', 'expansion', 'infrastructure'],
          'isBreaking': false,
          'viewCount': 1250,
          'likeCount': 89,
          'shareCount': 34,
        },
        {
          'id': 'news_002',
          'title': 'New Mobile App Features Released',
          'subtitle': 'Enhanced user experience with AI-powered support',
          'category': 'product_updates',
          'publishedDate': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'author': 'Product Development Team',
          'imageUrl': 'assets/images/news_app_update.jpg',
          'content':
              'Our latest mobile app update introduces several new features designed to improve your experience, including AI-powered customer support, enhanced bill management, and real-time service monitoring...',
          'summary':
              'Mobile app gets major update with AI support and new features.',
          'readTime': 2,
          'tags': ['mobile_app', 'ai', 'features'],
          'isBreaking': false,
          'viewCount': 890,
          'likeCount': 156,
          'shareCount': 78,
        },
        {
          'id': 'news_003',
          'title': '5G Network Launch in Major Cities',
          'subtitle': 'Next-generation mobile connectivity now available',
          'category': 'technology',
          'publishedDate': DateTime.now()
              .subtract(const Duration(days: 7))
              .toIso8601String(),
          'author': 'Technology Division',
          'imageUrl': 'assets/images/news_5g_launch.jpg',
          'content':
              'MultiSales officially launches its 5G network in Casablanca, Rabat, and Marrakech, offering unprecedented mobile internet speeds and low latency for enhanced digital experiences...',
          'summary': '5G network goes live in Morocco\'s three largest cities.',
          'readTime': 4,
          'tags': ['5g', 'mobile', 'technology'],
          'isBreaking': true,
          'viewCount': 2340,
          'likeCount': 234,
          'shareCount': 123,
        },
        {
          'id': 'news_004',
          'title': 'Green Initiative: 100% Renewable Energy Goal',
          'subtitle': 'Commitment to sustainable operations by 2025',
          'category': 'sustainability',
          'publishedDate': DateTime.now()
              .subtract(const Duration(days: 12))
              .toIso8601String(),
          'author': 'Sustainability Team',
          'imageUrl': 'assets/images/news_green_initiative.jpg',
          'content':
              'MultiSales announces its commitment to achieving 100% renewable energy for all operations by 2025, part of our comprehensive environmental sustainability program...',
          'summary': 'Company commits to 100% renewable energy by 2025.',
          'readTime': 5,
          'tags': ['sustainability', 'renewable_energy', 'environment'],
          'isBreaking': false,
          'viewCount': 567,
          'likeCount': 67,
          'shareCount': 23,
        },
        {
          'id': 'news_005',
          'title': 'Customer Service Excellence Award 2024',
          'subtitle': 'Recognized for outstanding customer satisfaction',
          'category': 'awards',
          'publishedDate': DateTime.now()
              .subtract(const Duration(days: 18))
              .toIso8601String(),
          'author': 'Customer Relations',
          'imageUrl': 'assets/images/news_award.jpg',
          'content':
              'MultiSales has been awarded the Customer Service Excellence Award 2024 by the Moroccan Telecommunications Authority, recognizing our commitment to exceptional customer service...',
          'summary': 'MultiSales wins prestigious customer service award.',
          'readTime': 2,
          'tags': ['award', 'customer_service', 'recognition'],
          'isBreaking': false,
          'viewCount': 445,
          'likeCount': 89,
          'shareCount': 45,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load news articles: $e');
      return false;
    }
  }

  // Load Personalized Offers
  Future<bool> _loadPersonalizedOffers(String clientId) async {
    try {
      // Simulate personalized offers based on client profile
      _personalizedOffers = [
        {
          'id': 'personal_001',
          'title': 'Upgrade Recommendation',
          'message':
              'Based on your usage, we recommend upgrading to our 500 Mbps plan.',
          'offerType': 'upgrade',
          'discountPercent': 25,
          'validUntil':
              DateTime.now().add(const Duration(days: 14)).toIso8601String(),
          'imageUrl': 'assets/images/personal_upgrade.jpg',
          'callToAction': 'Upgrade Now',
          'isViewed': false,
        },
        {
          'id': 'personal_002',
          'title': 'Loyalty Reward',
          'message':
              'As a valued customer, enjoy 2 months free on your next renewal.',
          'offerType': 'loyalty',
          'discountPercent': null,
          'validUntil':
              DateTime.now().add(const Duration(days: 30)).toIso8601String(),
          'imageUrl': 'assets/images/personal_loyalty.jpg',
          'callToAction': 'Claim Reward',
          'isViewed': false,
        },
        {
          'id': 'personal_003',
          'title': 'Family Plan Suggestion',
          'message': 'Add family members to your plan and save up to 40%.',
          'offerType': 'family',
          'discountPercent': 40,
          'validUntil':
              DateTime.now().add(const Duration(days: 21)).toIso8601String(),
          'imageUrl': 'assets/images/personal_family.jpg',
          'callToAction': 'Add Members',
          'isViewed': false,
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load personalized offers: $e');
      return false;
    }
  }

  // Load Subscription Preferences
  Future<bool> _loadSubscriptionPreferences(String clientId) async {
    try {
      _subscribedCategories = {
        'promotions': true,
        'product_updates': true,
        'company_news': false,
        'technology': true,
        'sustainability': false,
        'awards': false,
        'personal_offers': true,
      };

      return true;
    } catch (e) {
      _setError('Failed to load subscription preferences: $e');
      return false;
    }
  }

  // Apply Promo Code
  Future<Map<String, dynamic>?> applyPromoCode(String promoCode) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Check if promo code exists and is valid
      final promotion = _activePromotions.firstWhere(
        (promo) =>
            promo['promoCode'].toString().toLowerCase() ==
            promoCode.toLowerCase(),
        orElse: () => {},
      );

      if (promotion.isEmpty) {
        _setError('Invalid or expired promo code');
        _setLoading(false);
        return null;
      }

      // Check if already applied
      if (_appliedPromoCodes.contains(promoCode.toUpperCase())) {
        _setError('Promo code already applied');
        _setLoading(false);
        return null;
      }

      // Check validity dates
      final validUntil = DateTime.parse(promotion['validUntil']);
      if (DateTime.now().isAfter(validUntil)) {
        _setError('Promo code has expired');
        _setLoading(false);
        return null;
      }

      // Apply promo code
      _appliedPromoCodes.add(promoCode.toUpperCase());

      final result = {
        'promoCode': promoCode.toUpperCase(),
        'title': promotion['title'],
        'discountPercent': promotion['discountPercent'],
        'discountAmount': promotion['discountAmount'],
        'validUntil': promotion['validUntil'],
        'appliedAt': DateTime.now().toIso8601String(),
      };

      _setLoading(false);
      return result;
    } catch (e) {
      _setError('Failed to apply promo code: $e');
      _setLoading(false);
      return null;
    }
  }

  // Get Promotions by Category
  List<Map<String, dynamic>> getPromotionsByCategory(String category) {
    if (category == 'all') return _activePromotions;
    return _activePromotions
        .where((promo) => promo['category'] == category)
        .toList();
  }

  // Get News by Category
  List<Map<String, dynamic>> getNewsByCategory(String category) {
    if (category == 'all') return _newsArticles;
    return _newsArticles.where((news) => news['category'] == category).toList();
  }

  // Mark Promotion as Clicked
  Future<bool> trackPromotionClick(String promotionId) async {
    try {
      final promotionIndex =
          _activePromotions.indexWhere((p) => p['id'] == promotionId);
      if (promotionIndex != -1) {
        _activePromotions[promotionIndex]['clickCount']++;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Mark News as Read
  Future<bool> markNewsAsRead(String newsId) async {
    try {
      final newsIndex = _newsArticles.indexWhere((n) => n['id'] == newsId);
      if (newsIndex != -1) {
        _newsArticles[newsIndex]['viewCount']++;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update Subscription Preferences
  Future<bool> updateSubscriptionPreferences(
      Map<String, bool> preferences) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _subscribedCategories = {..._subscribedCategories, ...preferences};
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update preferences: $e');
      _setLoading(false);
      return false;
    }
  }

  // Set Category Filter
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Toggle Personalized Content
  void togglePersonalizedContent(bool enabled) {
    _showPersonalizedContent = enabled;
    notifyListeners();
  }

  // Mark Personal Offer as Viewed
  void markPersonalOfferAsViewed(String offerId) {
    final offerIndex =
        _personalizedOffers.indexWhere((o) => o['id'] == offerId);
    if (offerIndex != -1) {
      _personalizedOffers[offerIndex]['isViewed'] = true;
      notifyListeners();
    }
  }

  // Get Available Categories
  List<String> getPromotionCategories() {
    final categories =
        _activePromotions.map((p) => p['category'].toString()).toSet().toList();
    categories.insert(0, 'all');
    return categories;
  }

  List<String> getNewsCategories() {
    final categories =
        _newsArticles.map((n) => n['category'].toString()).toSet().toList();
    categories.insert(0, 'all');
    return categories;
  }

  // Get Unread Personal Offers Count
  int getUnreadPersonalOffersCount() {
    return _personalizedOffers.where((offer) => !offer['isViewed']).length;
  }

  // Get Breaking News
  List<Map<String, dynamic>> getBreakingNews() {
    return _newsArticles.where((news) => news['isBreaking'] == true).toList();
  }

  // Get Urgent Promotions
  List<Map<String, dynamic>> getUrgentPromotions() {
    return _activePromotions
        .where((promo) => promo['priority'] == 'urgent' && promo['isActive'])
        .toList();
  }
}
