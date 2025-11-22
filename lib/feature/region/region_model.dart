class Region {
  const Region({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;
}

const Region regionAll = Region(code: '', name: '경북 전체');

const List<Region> gyeongbukRegions = [
  Region(code: 'PLA0020001', name: '포항시'),
  Region(code: 'PLA0020002', name: '경주시'),
  Region(code: 'PLA0020003', name: '김천시'),
  Region(code: 'PLA0020004', name: '안동시'),
  Region(code: 'PLA0020005', name: '구미시'),
  Region(code: 'PLA0020006', name: '영주시'),
  Region(code: 'PLA0020007', name: '영천시'),
  Region(code: 'PLA0020008', name: '상주시'),
  Region(code: 'PLA0020009', name: '문경시'),
  Region(code: 'PLA0020010', name: '경산시'),
  Region(code: 'PLA0020011', name: '군위군'),
  Region(code: 'PLA0020012', name: '의성군'),
  Region(code: 'PLA0020013', name: '청송군'),
  Region(code: 'PLA0020014', name: '영양군'),
  Region(code: 'PLA0020015', name: '영덕군'),
  Region(code: 'PLA0020016', name: '청도군'),
  Region(code: 'PLA0020017', name: '고령군'),
  Region(code: 'PLA0020018', name: '성주군'),
  Region(code: 'PLA0020019', name: '칠곡군'),
  Region(code: 'PLA0020020', name: '예천군'),
  Region(code: 'PLA0020021', name: '봉화군'),
  Region(code: 'PLA0020022', name: '울진군'),
  Region(code: 'PLA0020023', name: '울릉군'),
];
