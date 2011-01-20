import java.io.File;
import java.util.ArrayList;
import javax.xml.parsers.*;
import org.w3c.dom.*;

public class Main {
	private static ArrayList<Article> articles = new ArrayList<Article>();

	private static ArrayList<Article> likedArticles = new ArrayList<Article>();
	private static ArrayList<Article> dislikedArticles = new ArrayList<Article>();
	
	private static ArrayList<Topic> topics = new ArrayList<Topic>();
	
	public static final int NUM_TOP_WORDS_FOR_TOPICS = 10;
	public static final int TITLE_TOP_WORD_MULT = 2;
	public static final double MIN_PERCENTAGE_FOR_TOPIC_ADD = 0.25;
	
	public static void main(String args[])
	{
		System.out.println("Getting articles...");
		getArticles(new File("articles.xml"));
		
		System.out.println("Creating a basis based on what data we have for liked and disliked articles...");
		for (Article article : articles)
		{
			if (article.getLike() == Likability.LIKE)
			{
				likedArticles.add(article);
			} else if (article.getLike() == Likability.NOTLIKE) {
				dislikedArticles.add(article);
			}
		}
		
		System.out.println("Narrowing down top words within articles...");
		
		System.out.println("Attempting to create topics...\n\n\n");
		for (Article article : articles)
		{
			if (topics.size() == 0)
			{
				Topic topic = new Topic(article.getTitle(), article);
				topics.add(topic);
				System.out.println("Creating new topic for "+article.getTitle());
				System.out.println("*************");
			} else {
				boolean added = false;
				for (int i = 0; i < topics.size(); i++)
				{
					Topic topic = topics.get(i);
					double percentage = topic.getCandidatePercentage(article);
					if (percentage >= MIN_PERCENTAGE_FOR_TOPIC_ADD)
					{
						topic.add(article);
						added = true;
						System.out.println("Added "+article.getTitle()+"\nTo Topic: "+topic.getName());
						break;
					}
				}
				if (!added)
				{
					Topic newTopic = new Topic(article.getTitle(), article);
					topics.add(newTopic);
					System.out.println("Creating new topic for "+article.getTitle());
				}
				System.out.println("*************");
			}
		}
		
		for (Topic topic : topics)
		{
			System.out.println(topic);
		}
	}
	
	public static void getArticles(File file)
	{
		try {
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.parse(file);
			doc.getDocumentElement().normalize();
			
			NodeList nodes = doc.getElementsByTagName("article");
			
			for (int i = 0; i < nodes.getLength(); i++)
			{
				String titleString, sourceString, authorString, bodyString;
				Likability likability = Likability.UNSURE;
				
				Node node = nodes.item(i);
				
				if (node.getNodeType() == Node.ELEMENT_NODE)
				{
					Element element = (Element)node;
					
				    NodeList titleNodeList = element.getElementsByTagName("title");
				    Element titleElement = (Element)titleNodeList.item(0);
				    NodeList title = titleElement.getChildNodes();
				    titleString = ((Node) title.item(0)).getNodeValue();

				    NodeList sourceNodeList = element.getElementsByTagName("source");
				    Element sourceElement = (Element)sourceNodeList.item(0);
				    NodeList source = sourceElement.getChildNodes();
				    sourceString = ((Node) source.item(0)).getNodeValue();

				    NodeList authorNodeList = element.getElementsByTagName("author");
				    Element authorElement = (Element)authorNodeList.item(0);
				    NodeList author = authorElement.getChildNodes();
				    authorString = ((Node) author.item(0)).getNodeValue();

				    NodeList bodyNodeList = element.getElementsByTagName("body");
				    Element bodyElement = (Element)bodyNodeList.item(0);
				    NodeList body = bodyElement.getChildNodes();
				    bodyString = ((Node) body.item(0)).getNodeValue();
				    
				    NodeList likeNodeList = element.getElementsByTagName("like");
				    if (likeNodeList.getLength() > 0)
				    {
					    Element likeElement = (Element)likeNodeList.item(0);
					    NodeList like = likeElement.getChildNodes();
					    String likeString = ((Node) like.item(0)).getNodeValue();
					    if (likeString.equals("LIKE"))
					    {
					    	likability = Likability.LIKE;
					    } else {
					    	likability = Likability.NOTLIKE;
					    }
				    } else {
				    	likability = Likability.UNSURE;
				    }
				    
				    articles.add(new Article(titleString, sourceString, authorString, bodyString, likability));
				}
			}
		} catch (Exception e) {
		    e.printStackTrace();
		}
	}
}