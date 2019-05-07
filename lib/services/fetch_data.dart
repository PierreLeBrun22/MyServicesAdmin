import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> getAllServices() async {
  List<String> _servicesList = [];
  CollectionReference ref = Firestore.instance.collection('services');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
    _servicesList.add(document.data['name']);
  });
  return _servicesList;
}

Future<List<String>> getServicesPackName(List<dynamic> servicesPack) async {
  List<String> _servicesList = [];
  CollectionReference ref = Firestore.instance.collection('services');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
    for (var i = 0; i < servicesPack.length; i++) {
      if (servicesPack[i] == document.documentID) {
        _servicesList.add(document.data['name']);
      }
    }
  });
  return _servicesList;
}

void createPack(String packName, List<String> services) async {
  List<String> _servicesList = [];
  CollectionReference ref = Firestore.instance.collection('services');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
    for (var i = 0; i < services.length; i++) {
     if(services[i] == document.data['name']) {
       _servicesList.add(document.documentID);
      } 
    }
  });

  Firestore.instance
        .collection('packs')
        .add({"name": packName, "services": _servicesList});
}

void updatePack(String packName, List<String> services, String packId) async {
   List<String> _servicesList = [];
  CollectionReference ref = Firestore.instance.collection('services');
  QuerySnapshot eventsQuery = await ref.getDocuments();
  eventsQuery.documents.forEach((document) {
    for (var i = 0; i < services.length; i++) {
     if(services[i] == document.data['name']) {
       _servicesList.add(document.documentID);
      } 
    }
  });

   Firestore.instance
            .collection('packs')
            .document(packId)
            .updateData(
          {"name": packName, "services": _servicesList},
        );
}

void createService(
    String serviceName,
    String serviceLocation,
    String serviceDescription,
    String serviceImage,
    List<String> servicePartners) async {

  Firestore.instance
      .collection('services')
      .add({"name": serviceName, "description": serviceDescription, "location": serviceLocation, "image": serviceImage, "partners": servicePartners});
}

void updateService(
    String serviceName,
    String serviceLocation,
    String serviceDescription,
    String serviceImage,
    List<String> servicePartners,
    String serviceId) async {

  Firestore.instance
      .collection('services')
      .document(serviceId)
      .updateData({"name": serviceName, "description": serviceDescription, "location": serviceLocation, "image": serviceImage, "partners": servicePartners});
}

void deletePack(String packDocumentId) {
  Firestore.instance
      .collection('packs').document(packDocumentId).delete();
}

void deleteService(String serviceDocumentId) {
  Firestore.instance
      .collection('services').document(serviceDocumentId).delete();
}