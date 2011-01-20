import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.regex.Pattern;

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
	
	public Article(String title, String source, String author, String body, Likability like)
	{
		this.title = title;
		this.source = source;
		this.author = author;
		this.body = body;
		this.like = like;
		
		analyze();
	}
	
	public void analyze()
	{
		numberOfLinks = 0;
		tags = new ArrayList<String>();
		
		String[] words = body.split(" ");
		numberOfWords = words.length;
		
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
		
		removeInvalidWords(topWords);		
		removeInvalidWords(titleTopWords);
	}
	
	public void removeInvalidWords(ArrayList<Word> words)
	{
		//Common word list from here: http://www.textfixer.com/resources/common-english-words.php
		ArrayList<Word> commonWords = new ArrayList<Word>();
		
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
		
		for (Word commonWord : commonWords)
		{
			if (words.contains(commonWord))
			{
				words.remove(words.indexOf(commonWord));
			}
		}
		
		for (int i = words.size()-1; i >= 0; i--)
		{
			Word word = words.get(i);
			
			if (Pattern.matches("\\d?\\W?", word.getWord()) || word.getWord() == null || (word.getWord()).length() < 5)
			{
				words.remove(word);
			}
		}
	}
	
	public Likability getLike()
	{
		return like;
	}
	
	public ArrayList<Word> getTopWords()
	{
		Collections.sort(topWords);
		return topWords;
	}
	
	public ArrayList<Word> getTitleTopWords()
	{
		Collections.sort(titleTopWords);
		return titleTopWords;
	}
	
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
	
	public String getTitle()
	{
		return title;
	}
	
	public String toString()
	{
		return "Title: "+title+"\nSource: "+source+"\nAuthor: "+author+"\nLike: "+like;
		//return "Article \""+title+"\" has "+numberOfWords+" words and these top words: "+topWords;
	}
}
