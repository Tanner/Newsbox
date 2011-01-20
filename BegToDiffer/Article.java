import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.regex.Pattern;

/**
 * The Article class.
 * 
 * Represents a news article from an RSS feed. Contains the qualities title, source, author, and body text.
 * 
 * @author Tanner Smith and Ryan Ashcraft
 */
public class Article {
	private String title;
	private String source; 
	private String author;
	private String body;
	
	private int numberOfWords = 0;
	private ArrayList<Word> topWords = new ArrayList<Word>();
	private ArrayList<Word> titleTopWords = new ArrayList<Word>();
	private int numberOfLinks = 0;
	private ArrayList<String> tags = new ArrayList<String>();
	
	private Likability like = Likability.UNSURE;
	
	/**
	 * Create a new Article object.
	 * @param title The article's title.
	 * @param source The article's source.
	 * @param author The article's author.
	 * @param body The article's body.
	 * @param like The article's likability enumeration value.
	 */
	public Article(String title, String source, String author, String body, Likability like)
	{
		this.title = title;
		this.source = source;
		this.author = author;
		this.body = body;
		this.like = like;
		
		analyze();
	}
	
	/**
	 * Analyzes the article into stuff that can actually be used to describe it quantitatively.
	 */
	public void analyze()
	{
		numberOfLinks = 0;
		tags = new ArrayList<String>();
		
		//Find the number of words.
		String[] words = body.split(" ");
		numberOfWords = words.length;
		
		//Count the frequencies of all the words within the article.
		topWords = new ArrayList<Word>();
		for (int i = 0; i < words.length; i++)
		{
			Word word = new Word(words[i].toLowerCase());
			if (topWords.contains(word))
			{
				Word thisWord = topWords.get(topWords.indexOf(word));
				thisWord.setValue(thisWord.getValue() + 1);
			} else {
				word.setValue(1);
				topWords.add(word);
			}
		}
		
		//Count the frequencies of all the words within the article's title.
		words = title.split(" ");
		for (int i = 0; i < words.length; i++)
		{
			Word word = new Word(words[i].toLowerCase());
			if (titleTopWords.contains(word))
			{
				Word thisWord = titleTopWords.get(titleTopWords.indexOf(word));
				thisWord.setValue(thisWord.getValue() + 1);
			} else {
				word.setValue(1);
				titleTopWords.add(word);
			}
		}
		
		//Remove invalid stuff from the word lists
		removeInvalidWords(topWords);		
		removeInvalidWords(titleTopWords);
	}
	
	/**
	 * Remove invalid words from the given ArrayList.
	 * @param words Given ArrayList to remove words from.
	 */
	public static void removeInvalidWords(ArrayList<Word> words)
	{
		//Common word list from here: http://www.textfixer.com/resources/common-english-words.php
		ArrayList<Word> commonWords = new ArrayList<Word>();
		
		//Read in the list of stop words from a file containing them CSV
		try {
		    BufferedReader bufferedReader = new BufferedReader(new FileReader("stop_words.txt"));
		    String line;
		    while ((line = bufferedReader.readLine()) != null) {
		        String[] wordsInLine = line.split(",");
		        for (int i = 0; i < wordsInLine.length; i++)
		        {
		        	commonWords.add(new Word(wordsInLine[i]));
		        }
		    }
		    bufferedReader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//If the words ArrayList contains a common word, remove it.
		for (Word commonWord : commonWords)
		{
			if (words.contains(commonWord))
			{
				words.remove(words.indexOf(commonWord));
			}
		}
		
		/*
		 * If a word has any of these qualities:
		 * 	- Contains a digit or non-letter character
		 *  - Word is null
		 *  - Length is less than 5
		 * Than the word is marked for extermination and is removed.
		 */
		for (int i = words.size()-1; i >= 0; i--)
		{
			Word word = words.get(i);
			
			if (Pattern.matches("\\d?\\W?", word.getWord()) || word.getWord() == null || (word.getWord()).length() < 5)
			{
				words.remove(word);
			}
		}
	}
	
	/**
	 * Get the likability enumeration value of this article
	 * @return Likability enumeration value
	 */
	public Likability getLike()
	{
		return like;
	}
	
	/**
	 * Get the body of the article.
	 * @return Body of the article.
	 */
	public String getBody()
	{
		return body;
	}
	
	/**
	 * Get the top words of this article.
	 * @return Top words (sorted).
	 */
	public ArrayList<Word> getTopWords()
	{
		Collections.sort(topWords);
		return topWords;
	}
	
	/**
	 * Get the title top words of this article.
	 * @return Title top words (sorted).
	 */
	public ArrayList<Word> getTitleTopWords()
	{
		Collections.sort(titleTopWords);
		return titleTopWords;
	}
	
	/**
	 * Get the overall list of top words (i.e. both title top words and article top words).
	 * @return Both title top words and article top words (sorted).
	 */
	public ArrayList<Word> getOverallTopWords()
	{
		ArrayList<Word> overallTopWords = new ArrayList<Word>();
		overallTopWords.addAll(topWords);
		
		for (Word word : titleTopWords)
		{
			if (overallTopWords.contains(word))
			{
				Word thisWord = overallTopWords.get(overallTopWords.indexOf(word));
				thisWord.setValue(thisWord.getValue() + (word.getValue() * Main.TITLE_TOP_WORD_MULT));
			} else {
				word.setValue(word.getValue() * Main.TITLE_TOP_WORD_MULT);
				overallTopWords.add(word);
			}
		}
		
		Collections.sort(overallTopWords);
		return overallTopWords;
	}
	
	/**
	 * Get the title of the article.
	 * @return Article's title.
	 */
	public String getTitle()
	{
		return title;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString()
	{
		return "Title: "+title+"\nSource: "+source+"\nAuthor: "+author+"\nLike: "+like;
		//return "Article \""+title+"\" has "+numberOfWords+" words and these top words: "+topWords;
	}
}
