
String GBSwifi(var wifiName){
  switch(wifiName){
    case "gbshs":
    case "G18_059":
      return "자습실 or 교실";
      break;
    case "LIBRARY_2.4G":
    case "LIBRARY_5G":
      return "도서실";
      break;

    case "Sound Room 2.4G":
    case "Sound Room 5G":
      return "음악실";
      break;

    case "Note_Station2":
      return "NoteStation2";
      break;

    case "gbshs_com1":
      return "컴퓨터실1";
      break;
    case "GBSHS_COM2":
      return "컴퓨터실2";
      break;

    case "GBS_EAR11":
    case "GBS_EAR11_5G":
    case "GBS_EAR":
    case "GBS_EAR_5G":
      return "지구과학실1";
      break;
    case "GBS_EAR22":
    case "GBS_EAR22_5G":
    case "GBS_EAR2":
    case "GBS_EAR2_5G":
      return "지구과학실2";
      break;

    case "GBS_PHY11":
    case "GBS_PHY11_5G":
    case "GBS_PHY":
    case "GBS_PHY_5G":
      return "물리실1";
      break;
    case "GBS_PHY22":
    case "GBS_PHY22_5G":
    case "GBS_PHY2":
    case "GBS_PHY2_5G":
      return "물리실2";
      break;

    case "GBS_CHE11":
    case "GBS_CHE11_5G":
    case "GBS_CHE":
    case "GBS_CHE_5G":
      return "화학실1";
      break;
    case "GBS_CHE22":
    case "GBS_CHE22_5G":
    case "GBS_CHE2":
    case "GBS_CHE2_5G":
    case "CHE2_2.4G":
      return "화학실2";
      break;

    case "GBS_BIO11":
    case "GBS_BIO11_5G":
    case "GBS_BIO":
    case "GBS_BIO_5G":
      return "생명실1";
      break;
    case "GBS_BIO22":
    case "GBS_BIO22_5G":
    case "GBS_BIO2":
    case "GBS_BIO2_5G":
      return "생명실2";
      break;

    default:
      return "확인불가";
      break;
  }
}