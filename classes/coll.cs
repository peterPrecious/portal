using System.Collections.Specialized;

namespace portal
{
  public class Coll
  {
    // this takes the querystring and returns the parameters in a collection needed for webclient
    public NameValueCollection getCollection(string postString)
    {
      NameValueCollection coll = new NameValueCollection();
      string[] pairs = postString.Split('&');
      foreach (var pair in pairs)
      {
        string[] values = pair.Split('=');
        coll.Add(values[0], values[1]);
      }
      return coll;
    }
  }

}