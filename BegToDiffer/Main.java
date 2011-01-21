import java.io.File;
import java.util.ArrayList;
import java.util.Scanner;

import javax.xml.parsers.*;
import org.w3c.dom.*;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.memory.AnalyzerUtil;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.search.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.NIOFSDirectory;
import org.apache.lucene.util.Version;

import java.io.IOException;

/**
 * This is the main class. Yay!
 * 
 * @author Tanner Smith and Ryan Ashcraft
 */
public class Main {
	private static ArrayList<Article> articles = new ArrayList<Article>();
	
	public static final int MAX_WORDS_FOR_TOPICS = 10;
	public static final int TITLE_TOP_WORD_MULT = 2;
	public static final double MIN_PERCENTAGE_FOR_TOPIC_ADD = 0.25;
	
	/**
	 * The main method. This get executed first and always.
	 * @param args Terms from the command line.
	 */
	public static void main(String args[]) throws IOException, ParseException
	{
		System.out.println("Getting articles...");
		getArticles(new File("articles.xml"));
		
		StandardAnalyzer analyzer = new StandardAnalyzer(Version.LUCENE_CURRENT);
		
	    //Directory index = new RAMDirectory();
		Directory index = new NIOFSDirectory(new File("index/"));
	    
	    IndexWriter w = new IndexWriter(index, analyzer, true, IndexWriter.MaxFieldLength.UNLIMITED);
	    
	    for (Article article : articles)
	    {
	    	addArticle(w, article);
	    }
	    
	    w.close();
	    
	    Scanner scanner = new Scanner(System.in);
	    System.out.print("Search Query: ");
	    String querystr = scanner.nextLine();
	    
	    String[] fields = {"title", "body"};
	    Query q = new MultiFieldQueryParser(Version.LUCENE_CURRENT, fields, analyzer).parse(querystr);
	    
	    //Search
	    int hitsPerPage = 10;
	    IndexSearcher searcher = new IndexSearcher(index, true);
	    TopScoreDocCollector collector = TopScoreDocCollector.create(hitsPerPage, true);
	    searcher.search(q, collector);
	    ScoreDoc[] hits = collector.topDocs().scoreDocs;
	    
	    //Display Results
	    System.out.println("Found " + hits.length + " hits.");
	    for (int i = 0; i < hits.length; i++)
	    {
	    	int docId = hits[i].doc;
	    	Document d = searcher.doc(docId);
	    	System.out.println((i + 1) + ". " + d.get("title")+" (score: "+hits[i].score+")");
	    }

	    searcher.close();
	    
	    String[] text = AnalyzerUtil.getMostFrequentTerms(analyzer, articles.get(0).getBody() + articles.get(0).getTitle(), 0);
	    for (int i = 0; i < text.length; i++)
	    {
	    	System.out.println(text[i]);
	    }
	}
	
	private static void addArticle(IndexWriter w, Article article) throws IOException
	{
		Document doc = new Document();
		doc.add(new Field("title", article.getTitle(), Field.Store.YES, Field.Index.ANALYZED));
		doc.add(new Field("body", article.getBody(), Field.Store.YES, Field.Index.ANALYZED));
		
		w.addDocument(doc);
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