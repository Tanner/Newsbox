import java.io.File;
import java.util.ArrayList;
import javax.xml.parsers.*;
import org.w3c.dom.*;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.RAMDirectory;
import org.apache.lucene.util.Version;

import java.io.IOException;

/**
 * This is the main class. Yay!
 * 
 * @author Tanner Smith and Ryan Ashcraft
 */
public class Main {
	private static ArrayList<Article> articles = new ArrayList<Article>();
	
	/**
	 * The main method. This get executed first and always.
	 * @param args Terms from the command line.
	 */
	public static void main(String args[])
	{
		System.out.println("Getting articles...");
		getArticles(new File("articles.xml"));
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
			org.w3c.dom.Document doc = db.parse(file);
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