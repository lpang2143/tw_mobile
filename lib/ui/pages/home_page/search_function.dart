import 'package:flutter/material.dart';
import 'package:tw_mobile/classes/leagues/mlb.dart';
import 'package:tw_mobile/classes/leagues/nba.dart';
import 'package:tw_mobile/classes/leagues/nhl.dart';
import 'package:tw_mobile/classes/leagues/nfl.dart';
import 'package:tw_mobile/classes/leagues/mls.dart';
import 'package:tw_mobile/classes/leagues/wnba.dart';
import 'package:tw_mobile/classes/leagues/nwsl.dart';
import 'package:tw_mobile/data/classes/team.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_mobile/ui/pages/team_page.dart';

class SearchTextField extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Team> searchResults = [];

  @override
  void initState() {
    _textEditingController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onSearchChanged);
    _textEditingController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    final text = _textEditingController.text;

    if (text.length >= 3) {
      searchResults = searchTeams(text);
    } else {
      searchResults = [];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x19091158),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: TextField(
                controller: _textEditingController,
                textAlignVertical: TextAlignVertical
                    .center, // Center aligns the text vertically
                decoration: InputDecoration(
                  hintText: 'Search by team, artist, event, or venue',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0x77091158),
                  ),
                  prefixIcon: IconButton(
                    onPressed: () {
                      final text = _textEditingController.text;
                      debugPrint('Search pressed. Entered text: $text');
                    },
                    icon: const Icon(Icons.search),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: searchResults
                  .map((team) => ListTile(
                      leading: SvgPicture.asset(
                        team.logoPath,
                        width: 24,
                        height: 24,
                      ),
                      title: Text(team.teamName),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeamPage(team: team)),
                        );
                      }))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }

  List<Team> searchTeams(String query) {
    // Combines all team lists from different files.
    List<Team> allTeams = [
      ...nbaTeams,
      ...mlbTeams,
      ...nflTeams,
      ...mlsTeams,
      ...nhlTeams,
      ...nwslTeams,
      ...wnbaTeams,
    ];

    // Search for matching teams
    return allTeams.where((team) {
      return team.teamName.toLowerCase().contains(query.toLowerCase()) ||
          team.arenaName.toLowerCase().contains(query.toLowerCase()) ||
          team.arenaLocation.toLowerCase().contains(query.toLowerCase()) ||
          team.state.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
