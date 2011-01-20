import java.io.File;
import java.util.ArrayList;
import javax.xml.parsers.*;
import org.w3c.dom.*;

/**
 * This is the main class. Yay!
 * 
 * @author Tanner Smith and Ryan Ashcraft
 */
public class Main {
	private static ArrayList<Article> articles = new ArrayList<Article>();

	private static ArrayList<Article> likedArticles = new ArrayList<Article>();
	private static ArrayList<Article> dislikedArticles = new ArrayList<Article>();
	
	private static ArrayList<Topic> topics = new ArrayList<Topic>();
	
	public static final int MAX_WORDS_FOR_TOPICS = 10;
	public static final int TITLE_TOP_WORD_MULT = 2;
	public static final double MIN_PERCENTAGE_FOR_TOPIC_ADD = 0.25;
	
	/**
	 * The main method. This get executed first and always.
	 * @param args Terms from the command line.
	 */
	public static void main(String args[])
	{
		System.out.println("Getting articles...");
		getArticles(new File("articles.xml"));
		
		//If the article has the like characteristic, add it to the corresponding array list
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
		
		//Loop through all the articles trying to place them in topics
		System.out.println("Attempting to create topics...\n\n\n");
		for (Article article : articles)
		{
			//If there are no topics, take the first article and make a topic out of it.
			if (topics.size() == 0)
			{
				Topic topic = new Topic(article.getTitle(), article);
				topics.add(topic);
				System.out.println("Creating new topic for "+article.getTitle());
				System.out.println("*************");
			} else {
				/*
				 * Otherwise if there are topics, loop through them checking the compatibility score against the min allowed.
				 * 
				 * If the score is above the min allowed, add it to the topic and move on in life.
				 * If we can't get a score above the min in any topics, create a new one. Simple.
				 */
				boolean foundTopic = false;
				for (int i = 0; i < topics.size(); i++)
				{
					Topic topic = topics.get(i);
					double percentage = topic.getCandidatePercentage(article);
					if (percentage >= MIN_PERCENTAGE_FOR_TOPIC_ADD)
					{
						topic.add(article);
						foundTopic = true;
						System.out.println("Added "+article.getTitle()+"\nTo Topic: "+topic.getName());
						break;
					}
				}
				if (!foundTopic)
				{
					Topic newTopic = new Topic(article.getTitle(), article);
					topics.add(newTopic);
					System.out.println("Creating new topic for "+article.getTitle());
				}
				System.out.println("*************");
			}
		}
		
		//And print out all the topics for funzies
		for (Topic topic : topics)
		{
			System.out.println(topic);
		}
	}
	
	/**
	 * Read a set of articles from an XML file and add store them.
	 * 
	 * @param file File object of the XML file to be read.
	 */
	public static void getArticles(File file)
	{
		try {
			//Start reading the file and prepare to parse it
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.parse(file);
			doc.getDocumentElement().normalize();
			
			NodeList nodes = doc.getElementsByTagName("article");
			
			//Start going through each node within the "articles" tag
			for (int i = 0; i < nodes.getLength(); i++)
			{
				String titleString, sourceString, authorString, bodyString;
				Likability likability = Likability.UNSURE;
				
				Node node = nodes.item(i);
				
				if (node.getNodeType() == Node.ELEMENT_NODE)
				{
					Element element = (Element)node;
					
					//Grab data from within each tag for title, source, author, and body
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
				    
				    //Check to see if the "like" tag exists and if so, change likability
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
				    
				    //Save the article
				    articles.add(new Article(titleString, sourceString, authorString, bodyString, likability));
				}
			}
		} catch (Exception e) {
		    e.printStackTrace();
		}
	}
}