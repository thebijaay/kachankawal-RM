import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/filter_options_widget.dart';
import './widgets/map_controls_widget.dart';
import './widgets/plot_details_popup_widget.dart';
import './widgets/search_bar_widget.dart';

class LandAndPropertySearch extends StatefulWidget {
  const LandAndPropertySearch({super.key});

  @override
  State<LandAndPropertySearch> createState() => _LandAndPropertySearchState();
}

class _LandAndPropertySearchState extends State<LandAndPropertySearch> {
  int _currentBottomNavIndex = 2;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  // Kachankawal Rural Municipality center coordinates
  static const LatLng _kachankawalCenter = LatLng(26.6544, 87.2718);

  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  Map<String, dynamic>? _selectedPlot;
  bool _showSatellite = false;
  bool _showFilterSheet = false;
  List<Map<String, dynamic>> _searchSuggestions = [];
  bool _showSuggestions = false;

  // Filter state
  String _selectedPlotSize = 'All';
  String _selectedTaxStatus = 'All';
  String _selectedOwnershipType = 'All';

  // Mock plot data for Kachankawal municipality
  final List<Map<String, dynamic>> _plotsData = [
    {
      "plotNumber": "KRM-W1-001",
      "ownerName": "राम बहादुर श्रेष्ठ",
      "ownerNameEn": "Ram Bahadur Shrestha",
      "address": "वडा नं. १, बनियानी",
      "addressEn": "Ward No. 1, Baniyani",
      "area": "5 आना",
      "areaEn": "5 Aana",
      "areaSqm": 318.0,
      "taxStatus": "Paid",
      "taxAmount": "रु. 2,500",
      "taxAmountEn": "Rs. 2,500",
      "lastPaymentDate": "2081/09/15",
      "ownershipType": "Private",
      "valuation": "रु. 25,00,000",
      "valuationEn": "Rs. 25,00,000",
      "coordinates": const LatLng(26.6544, 87.2718),
      "ownershipHistory": [
        {
          "year": "2078",
          "owner": "राम बहादुर श्रेष्ठ",
          "ownerEn": "Ram Bahadur Shrestha",
          "type": "Purchase"
        },
        {
          "year": "2070",
          "owner": "कृष्ण प्रसाद खड्का",
          "ownerEn": "Krishna Prasad Khadka",
          "type": "Inheritance"
        },
      ],
      "documents": [
        "Ownership Certificate",
        "Tax Receipt 2081",
        "Land Survey Map"
      ],
    },
    {
      "plotNumber": "KRM-W2-045",
      "ownerName": "सीता देवी यादव",
      "ownerNameEn": "Sita Devi Yadav",
      "address": "वडा नं. २, कचनकवल",
      "addressEn": "Ward No. 2, Kachankawal",
      "area": "8 आना",
      "areaEn": "8 Aana",
      "areaSqm": 509.0,
      "taxStatus": "Due",
      "taxAmount": "रु. 4,200",
      "taxAmountEn": "Rs. 4,200",
      "lastPaymentDate": "2080/12/30",
      "ownershipType": "Private",
      "valuation": "रु. 42,00,000",
      "valuationEn": "Rs. 42,00,000",
      "coordinates": const LatLng(26.6590, 87.2750),
      "ownershipHistory": [
        {
          "year": "2075",
          "owner": "सीता देवी यादव",
          "ownerEn": "Sita Devi Yadav",
          "type": "Purchase"
        },
      ],
      "documents": ["Ownership Certificate", "Land Survey Map"],
    },
    {
      "plotNumber": "KRM-W3-089",
      "ownerName": "मोहन कुमार साह",
      "ownerNameEn": "Mohan Kumar Sah",
      "address": "वडा नं. ३, धनगढी",
      "addressEn": "Ward No. 3, Dhangadhi",
      "area": "12 आना",
      "areaEn": "12 Aana",
      "areaSqm": 764.0,
      "taxStatus": "Paid",
      "taxAmount": "रु. 6,800",
      "taxAmountEn": "Rs. 6,800",
      "lastPaymentDate": "2081/08/22",
      "ownershipType": "Agricultural",
      "valuation": "रु. 58,00,000",
      "valuationEn": "Rs. 58,00,000",
      "coordinates": const LatLng(26.6620, 87.2680),
      "ownershipHistory": [
        {
          "year": "2079",
          "owner": "मोहन कुमार साह",
          "ownerEn": "Mohan Kumar Sah",
          "type": "Inheritance"
        },
        {
          "year": "2065",
          "owner": "रामदेव साह",
          "ownerEn": "Ramdev Sah",
          "type": "Purchase"
        },
      ],
      "documents": [
        "Ownership Certificate",
        "Tax Receipt 2081",
        "Agricultural Land Certificate"
      ],
    },
    {
      "plotNumber": "KRM-W4-123",
      "ownerName": "गीता कुमारी थापा",
      "ownerNameEn": "Gita Kumari Thapa",
      "address": "वडा नं. ४, सिमलबारी",
      "addressEn": "Ward No. 4, Simalbari",
      "area": "6 आना",
      "areaEn": "6 Aana",
      "areaSqm": 382.0,
      "taxStatus": "Paid",
      "taxAmount": "रु. 3,100",
      "taxAmountEn": "Rs. 3,100",
      "lastPaymentDate": "2081/10/05",
      "ownershipType": "Private",
      "valuation": "रु. 32,00,000",
      "valuationEn": "Rs. 32,00,000",
      "coordinates": const LatLng(26.6500, 87.2800),
      "ownershipHistory": [
        {
          "year": "2077",
          "owner": "गीता कुमारी थापा",
          "ownerEn": "Gita Kumari Thapa",
          "type": "Purchase"
        },
      ],
      "documents": ["Ownership Certificate", "Tax Receipt 2081"],
    },
    {
      "plotNumber": "KRM-W5-067",
      "ownerName": "विष्णु प्रसाद पौडेल",
      "ownerNameEn": "Bishnu Prasad Poudel",
      "address": "वडा नं. ५, महेन्द्रनगर",
      "addressEn": "Ward No. 5, Mahendranagar",
      "area": "10 आना",
      "areaEn": "10 Aana",
      "areaSqm": 636.0,
      "taxStatus": "Due",
      "taxAmount": "रु. 5,500",
      "taxAmountEn": "Rs. 5,500",
      "lastPaymentDate": "2080/11/18",
      "ownershipType": "Commercial",
      "valuation": "रु. 65,00,000",
      "valuationEn": "Rs. 65,00,000",
      "coordinates": const LatLng(26.6480, 87.2650),
      "ownershipHistory": [
        {
          "year": "2076",
          "owner": "विष्णु प्रसाद पौडेल",
          "ownerEn": "Bishnu Prasad Poudel",
          "type": "Purchase"
        },
      ],
      "documents": ["Ownership Certificate", "Commercial Land Certificate"],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _initializeMap() {
    _addMunicipalityBoundary();
    _addPlotMarkers();
  }

  void _addMunicipalityBoundary() {
    // Kachankawal municipality boundary polygon
    final List<LatLng> boundaryPoints = [
      const LatLng(26.6700, 87.2600),
      const LatLng(26.6700, 87.2850),
      const LatLng(26.6400, 87.2850),
      const LatLng(26.6400, 87.2600),
    ];

    setState(() {
      _polygons.add(
        Polygon(
          polygonId: const PolygonId('kachankawal_boundary'),
          points: boundaryPoints,
          strokeColor: Theme.of(context).colorScheme.primary,
          strokeWidth: 2,
          fillColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
      );
    });
  }

  void _addPlotMarkers() {
    final filteredPlots = _getFilteredPlots();

    setState(() {
      _markers.clear();
      for (var plot in filteredPlots) {
        _markers.add(
          Marker(
            markerId: MarkerId(plot["plotNumber"] as String),
            position: plot["coordinates"] as LatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _selectedPlot != null &&
                      _selectedPlot!["plotNumber"] == plot["plotNumber"]
                  ? BitmapDescriptor.hueBlue
                  : BitmapDescriptor.hueRed,
            ),
            onTap: () => _onPlotTapped(plot),
          ),
        );
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredPlots() {
    return _plotsData.where((plot) {
      final sizeMatch = _selectedPlotSize == 'All' ||
          (_selectedPlotSize == 'Small' && (plot["areaSqm"] as double) < 400) ||
          (_selectedPlotSize == 'Medium' &&
              (plot["areaSqm"] as double) >= 400 &&
              (plot["areaSqm"] as double) < 600) ||
          (_selectedPlotSize == 'Large' && (plot["areaSqm"] as double) >= 600);

      final taxMatch = _selectedTaxStatus == 'All' ||
          plot["taxStatus"] == _selectedTaxStatus;

      final ownershipMatch = _selectedOwnershipType == 'All' ||
          plot["ownershipType"] == _selectedOwnershipType;

      return sizeMatch && taxMatch && ownershipMatch;
    }).toList();
  }

  void _onPlotTapped(Map<String, dynamic> plot) {
    setState(() {
      _selectedPlot = plot;
    });
    _addPlotMarkers();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _showSuggestions = false;
        _searchSuggestions = [];
      });
      return;
    }

    final suggestions = _plotsData
        .where((plot) {
          final plotNumber = (plot["plotNumber"] as String).toLowerCase();
          final ownerName = (plot["ownerName"] as String).toLowerCase();
          final ownerNameEn = (plot["ownerNameEn"] as String).toLowerCase();
          final address = (plot["address"] as String).toLowerCase();
          final addressEn = (plot["addressEn"] as String).toLowerCase();
          final searchQuery = query.toLowerCase();

          return plotNumber.contains(searchQuery) ||
              ownerName.contains(searchQuery) ||
              ownerNameEn.contains(searchQuery) ||
              address.contains(searchQuery) ||
              addressEn.contains(searchQuery);
        })
        .take(5)
        .toList();

    setState(() {
      _searchSuggestions = suggestions;
      _showSuggestions = suggestions.isNotEmpty;
    });
  }

  void _onSuggestionSelected(Map<String, dynamic> plot) {
    _searchController.text = plot["plotNumber"] as String;
    setState(() {
      _showSuggestions = false;
      _selectedPlot = plot;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(plot["coordinates"] as LatLng, 16),
    );
    _addPlotMarkers();
  }

  void _toggleMapType() {
    setState(() {
      _showSatellite = !_showSatellite;
    });
  }

  void _moveToCurrentLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_kachankawalCenter, 14),
    );
  }

  void _applyFilters(String plotSize, String taxStatus, String ownershipType) {
    setState(() {
      _selectedPlotSize = plotSize;
      _selectedTaxStatus = taxStatus;
      _selectedOwnershipType = ownershipType;
      _showFilterSheet = false;
    });
    _addPlotMarkers();
  }

  void _navigateToPlotDetails() {
    if (_selectedPlot == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlotDetailsScreen(plot: _selectedPlot!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.search(
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
        searchHint: 'प्लट नम्बर, मालिक वा ठेगाना खोज्नुहोस्...',
        actions: [
          CustomAppBarActions.filter(
            onPressed: () {
              setState(() {
                _showFilterSheet = !_showFilterSheet;
              });
            },
            isActive: _selectedPlotSize != 'All' ||
                _selectedTaxStatus != 'All' ||
                _selectedOwnershipType != 'All',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Maps
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _kachankawalCenter,
              zoom: 14,
            ),
            mapType: _showSatellite ? MapType.satellite : MapType.normal,
            markers: _markers,
            polygons: _polygons,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (_) {
              setState(() {
                _selectedPlot = null;
                _showSuggestions = false;
              });
              _addPlotMarkers();
            },
          ),

          // Search suggestions
          if (_showSuggestions)
            SearchBarWidget(
              suggestions: _searchSuggestions,
              onSuggestionTap: _onSuggestionSelected,
            ),

          // Map controls
          MapControlsWidget(
            showSatellite: _showSatellite,
            onToggleMapType: _toggleMapType,
            onMoveToCurrentLocation: _moveToCurrentLocation,
          ),

          // Selected plot popup
          if (_selectedPlot != null)
            PlotDetailsPopupWidget(
              plot: _selectedPlot!,
              onViewDetails: _navigateToPlotDetails,
              onCalculateTax: () {
                // Navigate to tax calculator
              },
              onPayOnline: () {
                // Navigate to payment gateway
              },
              onClose: () {
                setState(() {
                  _selectedPlot = null;
                });
                _addPlotMarkers();
              },
            ),

          // Filter options sheet
          if (_showFilterSheet)
            FilterOptionsWidget(
              selectedPlotSize: _selectedPlotSize,
              selectedTaxStatus: _selectedTaxStatus,
              selectedOwnershipType: _selectedOwnershipType,
              onApplyFilters: _applyFilters,
              onClose: () {
                setState(() {
                  _showFilterSheet = false;
                });
              },
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.withDefaultItems(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });

          final routes = [
            '/dashboard',
            '/ward-information',
            '/land-and-property-search',
            '/profile-and-settings',
          ];

          if (index != 2) {
            Navigator.pushReplacementNamed(context, routes[index]);
          }
        },
      ),
    );
  }
}

// Plot Details Screen
class PlotDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> plot;

  const PlotDetailsScreen({super.key, required this.plot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: plot["plotNumber"] as String,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner Information Card
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'मालिक विवरण',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  _buildInfoRow(
                      context, 'मालिकको नाम:', plot["ownerName"] as String),
                  _buildInfoRow(context, 'ठेगाना:', plot["address"] as String),
                  _buildInfoRow(context, 'क्षेत्रफल:', plot["area"] as String),
                  _buildInfoRow(context, 'स्वामित्व प्रकार:',
                      plot["ownershipType"] as String),
                  _buildInfoRow(
                      context, 'मूल्याङ्कन:', plot["valuation"] as String),
                ],
              ),
            ),

            // Tax Information Card
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'कर विवरण',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  _buildInfoRow(
                      context, 'कर स्थिति:', plot["taxStatus"] as String),
                  _buildInfoRow(
                      context, 'कर रकम:', plot["taxAmount"] as String),
                  _buildInfoRow(context, 'अन्तिम भुक्तानी:',
                      plot["lastPaymentDate"] as String),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            // Ownership History
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'स्वामित्व इतिहास',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  ...(plot["ownershipHistory"] as List).map((history) {
                    final historyMap = history as Map<String, dynamic>;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Row(
                        children: [
                          Container(
                            width: 2.w,
                            height: 2.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  historyMap["year"] as String,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  historyMap["owner"] as String,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  historyMap["type"] as String,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            // Documents
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'कागजातहरू',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  ...(plot["documents"] as List).map((doc) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'description',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              doc as String,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'download',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
