using Dynamicweb.Extensibility.Notifications;
using Dynamicweb.Ecommerce.Products;

[Subscribe(Dynamicweb.Ecommerce.Notifications.Ecommerce.Product.BeforeRender)]
public class OrderCompleted : NotificationSubscriber
{
    public override void OnNotify(string notification, NotificationArgs args)
    {
        Dynamicweb.Ecommerce.Notifications.Ecommerce.Product.BeforeRenderArgs myArgs = (Dynamicweb.Ecommerce.Notifications.Ecommerce.Product.BeforeRenderArgs)args;
        Product product = myArgs.Product;
        // Do something with product. 
    }
}