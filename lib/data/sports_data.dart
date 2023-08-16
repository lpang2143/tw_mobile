import 'package:tw_mobile/ui/shared/sports_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';

final List<SportData> sportsData = [
  SportData(
    label: 'NBA',
    logo: SvgPicture.asset(
      'lib/assets/league_logos/NBA.svg',
    ),
  ),
  SportData(
    label: 'NFL',
    logo: SvgPicture.asset(
      'lib/assets/league_logos/NFL.svg',
    ),
  ),
  SportData(
    label: 'MLB',
    logo: SvgPicture.asset(
      'lib/assets/league_logos/MLB.svg',
    ),
  ),
  SportData(
    label: 'MLS',
    logo: SvgPicture.asset(
      'lib/assets/league_logos/MLS.svg',
    ),
  ),
  SportData(
    label: 'NHL',
    logo: SvgPicture.asset(
      'lib/assets/league_logos/NHL.svg',
    ),
  ),
  SportData(
    label: 'WNBA',
    logo: SvgPicture.asset(
      'lib/assets/league_logos/WNBA.svg',
    ),
  ),
];
