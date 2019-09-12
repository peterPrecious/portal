using System.ServiceModel;


namespace portal.services
{
  [ServiceContract]
  public interface vuAcctI
  {
    [OperationContract]
    string phpTest(string name);

    [OperationContract]
    string changePassword(string membAcctId, string membOldId, string membNewId);

    [OperationContract]
    string memberStatus(string custId, string membId);

    [OperationContract]
    string ecomSignIn(string ecomId, string ecomPwd);

    [OperationContract]
    string ecomAccountGet(string ecomGuid);
  }
}
