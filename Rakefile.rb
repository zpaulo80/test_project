#!/usr/bin/env rake
#encoding: utf-8
#@version 1.0


namespace :tests do
  namespace :code_analises do
    desc "Find duplicate code in app (requires flay gem installed)"
    task :dups do
      exec 'find . -name \*.rb | xargs flay -d'
    end

  end

  def calculate_time_elapsed(start)
    return (Time.now - start) * 1000.0
  end

  namespace :cucumber_tags do

    # some characters below may not appear ok.this is a font issue and is perfectly normal.always ensure this file is saved as UTF-8
    SPECIAL_CHARS = {
        'ï¼' => '0', 'ï¼‘' => '1', 'ï¼’' => '2', 'ï¼“' => '3', 'ï¼”' => '4', 'ï¼•' => '5', 'ï¼–' => '6', 'ï¼—' => '7', 'ï¼˜' => '8',
        'ï¼™' => '9', 'ï¼¡' => 'A', 'ï¼¢' => 'B', 'ï¼£' => 'C', 'ï¼¤' => 'D', 'ï¼¥' => 'E', 'ï¼¦' => 'F', 'ï¼§' => 'G',
        'ï¼¨' => 'H', 'ï¼©' => 'I', 'ï¼ª' => 'J', 'ï¼«' => 'K', 'ï¼¬' => 'L', 'ï¼­' => 'M', 'ï¼®' => 'N', 'ï¼¯' => 'O', 'ï¼°' => 'P',
        'ï¼±' => 'Q', 'ï¼²' => 'R', 'ï¼³' => 'S', 'ï¼´' => 'T', 'ï¼µ' => 'U', 'ï¼¶' => 'V', 'ï¼·' => 'W', 'ï¼¸' => 'X', 'ï¼¹' => 'Y',
        'ï¼º' => 'Z', 'ï½' => 'a', 'ï½‚' => 'b', 'ï½ƒ' => 'c', 'ï½„' => 'd', 'ï½…' => 'e', 'ï½†' => 'f', 'ï½‡' => 'g', 'ï½ˆ' => 'h',
        'ï½‰' => 'i', 'ï½Š' => 'j', 'ï½‹' => 'k', 'ï½Œ' => 'l', 'ï½' => 'm', 'ï½Ž' => 'n', 'ï½' => 'o', 'ï½' => 'p', 'ï½‘' => 'q',
        'ï½’' => 'r', 'ï½“' => 's', 'ï½”' => 't', 'ï½•' => 'u', 'ï½–' => 'v', 'ï½—' => 'w', 'ï½˜' => 'x', 'ï½™' => 'y', 'ï½š' => 'z',
        'Ã€' => 'A', 'Ã' => 'A', 'Ã‚' => 'A', 'Ãƒ' => 'A', 'Ã„' => 'A', 'Ã…' => 'A', 'Ã ' => 'a', 'Ã¡' => 'a', 'Ã¢' => 'a',
        'Ã£' => 'a', 'Ã¤' => 'a', 'Ã¥' => 'a', 'Ä€' => 'A', 'Ä' => 'a', 'Ä‚' => 'A', 'Äƒ' => 'a', 'Ä„' => 'A', 'Ä…' => 'a',
        'Ç' => 'A', 'ÇŽ' => 'a', 'Çž' => 'A', 'ÇŸ' => 'a', 'Ç ' => 'A', 'Ç¡' => 'a', 'Çº' => 'A', 'Ç»' => 'a', 'È€' => 'A',
        'È' => 'a', 'È‚' => 'A', 'Èƒ' => 'a', 'È¦' => 'A', 'È§' => 'a', 'Èº' => 'A', 'É' => 'a', 'Ó' => 'A', 'Ó‘' => 'a',
        'á´¬' => 'a', 'áµƒ' => 'a', 'áµ„' => 'a', 'á¶' => 'a', 'á¸€' => 'A', 'á¸' => 'a', 'áºš' => 'a', 'áº ' => 'A', 'áº¡' => 'a',
        'áº¢' => 'A', 'áº£' => 'a', 'áº¤' => 'A', 'áº¥' => 'a', 'áº¦' => 'A', 'áº§' => 'a', 'áº¨' => 'A', 'áº©' => 'a', 'áºª' => 'A',
        'áº«' => 'a', 'áº¬' => 'A', 'áº­' => 'a', 'áº®' => 'A', 'áº¯' => 'a', 'áº°' => 'A', 'áº±' => 'a', 'áº²' => 'A', 'áº³' => 'a',
        'áº´' => 'A', 'áºµ' => 'a', 'áº¶' => 'A', 'áº·' => 'a', 'â‚' => 'a', 'â±¥' => 'a',
        'Æ€' => 'b', 'Æ' => 'B', 'Æ‚' => 'B', 'Æƒ' => 'b', 'Éƒ' => 'B', 'É“' => 'b', 'Ê™' => 'b', 'á›’' => 'b', 'á´ƒ' => 'b',
        'á´®' => 'b', 'á´¯' => 'b', 'áµ‡' => 'b', 'áµ¬' => 'b', 'á¶€' => 'b', 'á¸‚' => 'B', 'á¸ƒ' => 'b', 'á¸„' => 'B', 'á¸…' => 'b',
        'á¸†' => 'B', 'á¸‡' => 'b', 'Ã‡' => 'C', 'Ã§' => 'c', 'Ä†' => 'C', 'Ä‡' => 'c', 'Äˆ' => 'C', 'Ä‰' => 'c', 'ÄŠ' => 'C',
        'Ä‹' => 'c', 'ÄŒ' => 'C', 'Ä' => 'c', 'Æ‡' => 'C', 'Æˆ' => 'c', 'È»' => 'C', 'È¼' => 'c', 'É•' => 'c', 'Ê—' => 'c',
        'á¶œ' => 'c', 'á¶' => 'c', 'á¸ˆ' => 'C', 'á¸‰' => 'c', 'â„­' => 'C', 'â†„' => 'c', 'ÄŽ' => 'D', 'Ä' => 'd', 'Ä' => 'D', 'Ä‘' => 'd', 'Æ‰' => 'D', 'ÆŠ' => 'D', 'Æ‹' => 'D', 'ÆŒ' => 'd', 'Ç…' => 'd', 'Ç²' => 'd', 'È¡' => 'd', 'É–' => 'd', 'É—' => 'd', 'á´…' => 'd', 'á´°' => 'd', 'áµˆ' => 'd', 'áµ­' => 'd', 'á¶' => 'd', 'á¶‘' => 'd', 'á¸Š' => 'D', 'á¸‹' => 'd', 'á¸Œ' => 'D', 'á¸' => 'd', 'á¸Ž' => 'D', 'á¸' => 'd', 'á¸' => 'D', 'á¸‘' => 'd', 'á¸’' => 'D', 'á¸“' => 'd',
        'Ãˆ' => 'E', 'Ã‰' => 'E', 'ÃŠ' => 'E', 'Ã‹' => 'E', 'Ã¨' => 'e', 'Ã©' => 'e', 'Ãª' => 'e', 'Ã«' => 'e', 'Ä’' => 'E', 'Ä“' => 'e', 'Ä”' => 'E', 'Ä•' => 'e', 'Ä–' => 'E', 'Ä—' => 'e', 'Ä˜' => 'E', 'Ä™' => 'e', 'Äš' => 'E', 'Ä›' => 'e', 'ÆŽ' => 'E', 'Æ' => 'E', 'Ç' => 'e', 'È„' => 'E', 'È…' => 'e', 'È†' => 'E', 'È‡' => 'e', 'È¨' => 'E', 'È©' => 'e', 'É†' => 'E', 'É‡' => 'e', 'É˜' => 'e', 'É›' => 'e', 'Éœ' => 'e', 'É' => 'e', 'Éž' => 'e', 'Êš' => 'e', 'á´‡' => 'e', 'á´ˆ' => 'e', 'á´±' => 'e', 'á´²' => 'e', 'áµ‰' => 'e', 'áµ‹' => 'e', 'áµŒ' => 'e', 'á¶’' => 'e', 'á¶“' => 'e', 'á¶”' => 'e', 'á¶Ÿ' => 'e', 'á¸”' => 'E', 'á¸•' => 'e', 'á¸–' => 'E', 'á¸—' => 'e', 'á¸˜' => 'E', 'á¸™' => 'e', 'á¸š' => 'E', 'á¸›' => 'e', 'á¸œ' => 'E', 'á¸' => 'e', 'áº¸' => 'E', 'áº¹' => 'e', 'áºº' => 'E', 'áº»' => 'e', 'áº¼' => 'E', 'áº½' => 'e', 'áº¾' => 'E', 'áº¿' => 'e', 'á»€' => 'E', 'á»' => 'e', 'á»‚' => 'E', 'á»ƒ' => 'e', 'á»„' => 'E', 'á»…' => 'e', 'á»†' => 'E', 'á»‡' => 'e', 'â‚‘' => 'e',
        'Æ‘' => 'F', 'Æ’' => 'f', 'áµ®' => 'f', 'á¶‚' => 'f', 'á¶ ' => 'f', 'á¸ž' => 'F', 'á¸Ÿ' => 'f',
        'Äœ' => 'G', 'Ä' => 'g', 'Äž' => 'G', 'ÄŸ' => 'g', 'Ä ' => 'G', 'Ä¡' => 'g', 'Ä¢' => 'G', 'Ä£' => 'g', 'Æ“' => 'G', 'Ç¤' => 'G', 'Ç¥' => 'g', 'Ç¦' => 'G', 'Ç§' => 'g', 'Ç´' => 'G', 'Çµ' => 'g', 'É ' => 'g', 'É¡' => 'g', 'É¢' => 'g', 'Ê›' => 'g', 'á´³' => 'g', 'áµ' => 'g', 'áµ·' => 'g', 'áµ¹' => 'g', 'á¶ƒ' => 'g', 'á¶¢' => 'g', 'á¸ ' => 'G', 'á¸¡' => 'g',
        'Ä¤' => 'H', 'Ä¥' => 'h', 'Ä¦' => 'H', 'Ä§' => 'h', 'Èž' => 'H', 'ÈŸ' => 'h', 'É¥' => 'h', 'É¦' => 'h', 'Êœ' => 'h', 'Ê®' => 'h', 'Ê¯' => 'h', 'Ê°' => 'h', 'Ê±' => 'h', 'á´´' => 'h', 'á¶£' => 'h', 'á¸¢' => 'H', 'á¸£' => 'h', 'á¸¤' => 'H', 'á¸¥' => 'h', 'á¸¦' => 'H', 'á¸§' => 'h', 'á¸¨' => 'H', 'á¸©' => 'h', 'á¸ª' => 'H', 'á¸«' => 'h', 'áº–' => 'h', 'â„Œ' => 'H', 'â±§' => 'H', 'â±¨' => 'h', 'â±µ' => 'H', 'â±¶' => 'h',
        'ÃŒ' => 'I', 'Ã' => 'I', 'ÃŽ' => 'I', 'Ã' => 'I', 'Ã¬' => 'i', 'Ã­' => 'i', 'Ã®' => 'i', 'Ã¯' => 'i', 'Ä¨' => 'I', 'Ä©' => 'i', 'Äª' => 'I', 'Ä«' => 'i', 'Ä¬' => 'I', 'Ä­' => 'i', 'Ä®' => 'I', 'Ä¯' => 'i', 'Ä°' => 'I', 'Ä±' => 'i', 'Æ—' => 'I', 'Ç' => 'I', 'Ç' => 'i', 'Èˆ' => 'I', 'È‰' => 'i', 'ÈŠ' => 'I', 'È‹' => 'i', 'É¨' => 'i', 'Éª' => 'i', 'Ð' => 'I', 'Ð˜' => 'I', 'Ð™' => 'I', 'Ð¸' => 'i', 'Ð¹' => 'i', 'Ñ–' => 'i', 'á´‰' => 'i', 'á´µ' => 'i', 'áµŽ' => 'i', 'áµ¢' => 'i', 'áµ»' => 'i', 'á¶–' => 'i', 'á¶¤' => 'i', 'á¶¦' => 'i', 'á¶§' => 'i', 'á¸¬' => 'I', 'á¸­' => 'i', 'á¸®' => 'I', 'á¸¯' => 'i', 'á»ˆ' => 'I', 'á»‰' => 'i', 'á»Š' => 'I', 'á»‹' => 'i', 'â±' => 'i', 'â„‘' => 'I',
        'Ä´' => 'J', 'Äµ' => 'j', 'Çˆ' => 'j', 'Ç‹' => 'j', 'Ç°' => 'j', 'È·' => 'j', 'Éˆ' => 'J', 'É‰' => 'j', 'ÉŸ' => 'j', 'Ê„' => 'j', 'Ê' => 'j', 'Ê²' => 'j', 'á´Š' => 'j', 'á´¶' => 'j', 'á¶¡' => 'j', 'á¶¨' => 'j',
        'Ä¶' => 'K', 'Ä·' => 'k', 'Æ˜' => 'K', 'Æ™' => 'k', 'Ç¨' => 'K', 'Ç©' => 'k', 'Êž' => 'k', 'á´‹' => 'k', 'á´·' => 'k', 'áµ' => 'k', 'á¶„' => 'k', 'á¸°' => 'K', 'á¸±' => 'k', 'á¸²' => 'K', 'á¸³' => 'k', 'á¸´' => 'K', 'á¸µ' => 'k', 'â±©' => 'K', 'â±ª' => 'k',
        'Ä¹' => 'L', 'Äº' => 'l', 'Ä»' => 'L', 'Ä¼' => 'l', 'Ä½' => 'L', 'Ä¾' => 'l', 'Ä¿' => 'L', 'Å€' => 'l', 'Å' => 'L', 'Å‚' => 'l', 'Æš' => 'l', 'Çˆ' => 'l', 'È´' => 'l', 'È½' => 'L', 'É«' => 'l', 'É¬' => 'l', 'É­' => 'l', 'ÊŸ' => 'l', 'Ë¡' => 'l', 'á´Œ' => 'l', 'á´¸' => 'l', 'á¶…' => 'l', 'á¶©' => 'l', 'á¶ª' => 'l', 'á¶«' => 'l', 'á¸¶' => 'L', 'á¸·' => 'l', 'á¸¸' => 'L', 'á¸¹' => 'l', 'á¸º' => 'L', 'á¸»' => 'l', 'á¸¼' => 'L', 'á¸½' => 'l', 'â± ' => 'L', 'â±¡' => 'l', 'â±¢' => 'L',
        'Æœ' => 'M', 'É¯' => 'm', 'É°' => 'm', 'É±' => 'm', 'á´' => 'm', 'á´Ÿ' => 'm', 'á´¹' => 'm', 'áµ' => 'm', 'áµš' => 'm', 'áµ¯' => 'm', 'á¶†' => 'm', 'á¶¬' => 'm', 'á¶­' => 'm', 'á¸¾' => 'M', 'á¸¿' => 'm', 'á¹€' => 'M', 'á¹' => 'm', 'á¹‚' => 'M', 'á¹ƒ' => 'm',
        'Ã‘' => 'N', 'Ã±' => 'n', 'Åƒ' => 'N', 'Å„' => 'n', 'Å…' => 'N', 'Å†' => 'n', 'Å‡' => 'N', 'Åˆ' => 'n', 'Å‰' => 'n', 'Æ' => 'N', 'Æž' => 'n', 'Ç‹' => 'n', 'Ç¸' => 'N', 'Ç¹' => 'n', 'È ' => 'N', 'Èµ' => 'n', 'É²' => 'n', 'É³' => 'n', 'É´' => 'n', 'á´Ž' => 'n', 'á´º' => 'n', 'á´»' => 'n', 'áµ°' => 'n', 'á¶‡' => 'n', 'á¶®' => 'n', 'á¶¯' => 'n', 'á¶°' => 'n', 'á¹„' => 'N', 'á¹…' => 'n', 'á¹†' => 'N', 'á¹‡' => 'n', 'á¹ˆ' => 'N', 'á¹‰' => 'n', 'á¹Š' => 'N', 'á¹‹' => 'n', 'â¿' => 'n',
        'Ã’' => 'O', 'Ã“' => 'O', 'Ã”' => 'O', 'Ã•' => 'O', 'Ã–' => 'O', 'Ã˜' => 'O', 'Ã²' => 'o', 'Ã³' => 'o', 'Ã´' => 'o', 'Ãµ' => 'o', 'Ã¶' => 'o', 'Ã¸' => 'o', 'ÅŒ' => 'O', 'Å' => 'o', 'ÅŽ' => 'O', 'Å' => 'o', 'Å' => 'O', 'Å‘' => 'o', 'Æ†' => 'O', 'ÆŸ' => 'O', 'Æ ' => 'O', 'Æ¡' => 'o', 'Ç‘' => 'O', 'Ç’' => 'o', 'Çª' => 'O', 'Ç«' => 'o', 'Ç¬' => 'O', 'Ç­' => 'o', 'Ç¾' => 'O', 'Ç¿' => 'o', 'ÈŒ' => 'O', 'È' => 'o', 'ÈŽ' => 'O', 'È' => 'o', 'Èª' => 'O', 'È«' => 'o', 'È¬' => 'O', 'È­' => 'o', 'È®' => 'O', 'È¯' => 'o', 'È°' => 'O', 'È±' => 'o', 'É”' => 'o', 'Éµ' => 'o', 'Ð¾' => 'o', 'Ó¦' => 'O', 'Ó§' => 'o', 'Ó¨' => 'O', 'Ó©' => 'o', 'Óª' => 'O', 'Ó«' => 'o', 'á´' => 'o', 'á´' => 'o', 'á´‘' => 'o', 'á´’' => 'o', 'á´“' => 'o', 'á´–' => 'o', 'á´—' => 'o', 'á´¼' => 'o', 'áµ’' => 'o', 'áµ“' => 'o', 'áµ”' => 'o', 'áµ•' => 'o', 'á¶—' => 'o', 'á¶±' => 'o', 'á¹Œ' => 'O', 'á¹' => 'o', 'á¹Ž' => 'O', 'á¹' => 'o', 'á¹' => 'O', 'á¹‘' => 'o', 'á¹’' => 'O', 'á¹“' => 'o', 'á»Œ' => 'O', 'á»' => 'o', 'á»Ž' => 'O', 'á»' => 'o', 'á»' => 'O', 'á»‘' => 'o', 'á»’' => 'O', 'á»“' => 'o', 'á»”' => 'O', 'á»•' => 'o', 'á»–' => 'O', 'á»—' => 'o', 'á»˜' => 'O', 'á»™' => 'o', 'á»š' => 'O', 'á»›' => 'o', 'á»œ' => 'O', 'á»' => 'o', 'á»ž' => 'O', 'á»Ÿ' => 'o', 'á» ' => 'O', 'á»¡' => 'o', 'á»¢' => 'O', 'á»£' => 'o', 'â‚’' => 'o', 'â²ž' => 'O', 'â²Ÿ' => 'o',
        'Æ¤' => 'P', 'Æ¥' => 'p', 'á´˜' => 'p', 'á´¾' => 'p', 'áµ–' => 'p', 'áµ±' => 'p', 'áµ½' => 'p', 'á¶ˆ' => 'p', 'á¹”' => 'P', 'á¹•' => 'p', 'á¹–' => 'P', 'á¹—' => 'p', 'â±£' => 'P',
        'ÉŠ' => 'Q', 'É‹' => 'q', 'Ê ' => 'q',
        'Å”' => 'R', 'Å•' => 'r', 'Å–' => 'R', 'Å—' => 'r', 'Å˜' => 'R', 'Å™' => 'r', 'È' => 'R', 'È‘' => 'r', 'È’' => 'R', 'È“' => 'r', 'ÉŒ' => 'R', 'É' => 'r', 'É¹' => 'r', 'Éº' => 'r', 'É»' => 'r', 'É¼' => 'r', 'É½' => 'r', 'É¾' => 'r', 'É¿' => 'r', 'Ê€' => 'r', 'Ê' => 'r', 'Ê³' => 'r', 'Ê´' => 'r', 'Êµ' => 'r', 'Ê¶' => 'r', 'á´™' => 'r', 'á´š' => 'r', 'á´¿' => 'r', 'áµ£' => 'r', 'áµ²' => 'r', 'áµ³' => 'r', 'á¶‰' => 'r', 'á·Š' => 'r', 'á¹˜' => 'R', 'á¹™' => 'r', 'á¹š' => 'R', 'á¹›' => 'r', 'á¹œ' => 'R', 'á¹' => 'r', 'á¹ž' => 'R', 'á¹Ÿ' => 'r', 'â„œ' => 'R', 'â±¤' => 'R',
        'ÃŸ' => 's', 'Åš' => 'S', 'Å›' => 's', 'Åœ' => 'S', 'Å' => 's', 'Åž' => 'S', 'ÅŸ' => 's', 'Å ' => 'S', 'Å¡' => 's', 'Å¿' => 's', 'È˜' => 'S', 'È™' => 's', 'È¿' => 's', 'Ê‚' => 's', 'Ë¢' => 's', 'áµ´' => 's', 'á¶Š' => 's', 'á¶³' => 's', 'á¹ ' => 'S', 'á¹¡' => 's', 'á¹¢' => 'S', 'á¹£' => 's', 'á¹¤' => 'S', 'á¹¥' => 's', 'á¹¦' => 'S', 'á¹§' => 's', 'á¹¨' => 'S', 'á¹©' => 's', 'áº›' => 's',
        'Å¢' => 'T', 'Å£' => 't', 'Å¤' => 'T', 'Å¥' => 't', 'Å¦' => 'T', 'Å§' => 't', 'Æ«' => 't', 'Æ¬' => 'T', 'Æ­' => 't', 'Æ®' => 'T', 'Èš' => 'T', 'È›' => 't', 'È¶' => 't', 'È¾' => 'T', 'Ê‡' => 't', 'Êˆ' => 't', 'á´›' => 't', 'áµ€' => 't', 'áµ—' => 't', 'áµµ' => 't', 'á¶µ' => 't', 'á¹ª' => 'T', 'á¹«' => 't', 'á¹¬' => 'T', 'á¹­' => 't', 'á¹®' => 'T', 'á¹¯' => 't', 'á¹°' => 'T', 'á¹±' => 't', 'áº—' => 't', 'â±¦' => 't',
        'Ã™' => 'U', 'Ãš' => 'U', 'Ã›' => 'U', 'Ãœ' => 'U', 'Ã¹' => 'u', 'Ãº' => 'u', 'Ã»' => 'u', 'Ã¼' => 'u', 'Å¨' => 'U', 'Å©' => 'u', 'Åª' => 'U', 'Å«' => 'u', 'Å¬' => 'U', 'Å­' => 'u', 'Å®' => 'U', 'Å¯' => 'u', 'Å°' => 'U', 'Å±' => 'u', 'Å²' => 'U', 'Å³' => 'u', 'Æ¯' => 'U', 'Æ°' => 'u', 'Ç“' => 'U', 'Ç”' => 'u', 'Ç•' => 'U', 'Ç–' => 'u', 'Ç—' => 'U', 'Ç˜' => 'u', 'Ç™' => 'U', 'Çš' => 'u', 'Ç›' => 'U', 'Çœ' => 'u', 'È”' => 'U', 'È•' => 'u', 'È–' => 'U', 'È—' => 'u', 'É„' => 'U', 'Ê‰' => 'u', 'á´œ' => 'u', 'á´' => 'u', 'á´ž' => 'u', 'áµ' => 'u', 'áµ˜' => 'u', 'áµ™' => 'u', 'áµ¤' => 'u', 'áµ¾' => 'u', 'á¶™' => 'u', 'á¶¶' => 'u', 'á¶¸' => 'u', 'á¹²' => 'U', 'á¹³' => 'u', 'á¹´' => 'U', 'á¹µ' => 'u', 'á¹¶' => 'U', 'á¹·' => 'u', 'á¹¸' => 'U', 'á¹¹' => 'u', 'á¹º' => 'U', 'á¹»' => 'u', 'á»¤' => 'U', 'á»¥' => 'u', 'á»¦' => 'U', 'á»§' => 'u', 'á»¨' => 'U', 'á»©' => 'u', 'á»ª' => 'U', 'á»«' => 'u', 'á»¬' => 'U', 'á»­' => 'u', 'á»®' => 'U', 'á»¯' => 'u', 'á»°' => 'U', 'á»±' => 'u',
        'Æ²' => 'V', 'É…' => 'V', 'Ê‹' => 'v', 'ÊŒ' => 'v', 'á´ ' => 'v', 'áµ›' => 'v', 'áµ¥' => 'v', 'á¶Œ' => 'v', 'á¶¹' => 'v', 'á¶º' => 'v', 'á¹¼' => 'V', 'á¹½' => 'v', 'á¹¾' => 'V', 'á¹¿' => 'v', 'â±´' => 'v',
        'Å´' => 'W', 'Åµ' => 'w', 'Ê' => 'w', 'Ê·' => 'w', 'á´¡' => 'w', 'áµ‚' => 'w', 'áº€' => 'W', 'áº' => 'w', 'áº‚' => 'W', 'áºƒ' => 'w', 'áº„' => 'W', 'áº…' => 'w', 'áº†' => 'W', 'áº‡' => 'w', 'áºˆ' => 'W', 'áº‰' => 'w', 'áº˜' => 'w',
        'Ë£' => 'x', 'á¶' => 'x', 'áºŠ' => 'X', 'áº‹' => 'x', 'áºŒ' => 'X', 'áº' => 'x', 'â‚“' => 'x',
        'Ã' => 'Y', 'Ã½' => 'y', 'Ã¿' => 'y', 'Å¶' => 'Y', 'Å·' => 'y', 'Å¸' => 'Y', 'Æ³' => 'Y', 'Æ´' => 'y', 'È²' => 'Y', 'È³' => 'y', 'ÉŽ' => 'Y', 'É' => 'y', 'ÊŽ' => 'y', 'Ê' => 'y', 'Ê¸' => 'y', 'áºŽ' => 'Y', 'áº' => 'y', 'áº™' => 'y', 'á»²' => 'Y', 'á»³' => 'y', 'á»´' => 'Y', 'á»µ' => 'y', 'á»¶' => 'Y', 'á»·' => 'y', 'á»¸' => 'Y', 'á»¹' => 'y',
        'Å¹' => 'Z', 'Åº' => 'z', 'Å»' => 'Z', 'Å¼' => 'z', 'Å½' => 'Z', 'Å¾' => 'z', 'Æµ' => 'Z', 'Æ¶' => 'z', 'È¤' => 'Z', 'È¥' => 'z', 'É€' => 'z', 'Ê' => 'z', 'Ê‘' => 'z', 'á´¢' => 'z', 'áµ¶' => 'z', 'á¶Ž' => 'z', 'á¶»' => 'z', 'á¶¼' => 'z', 'á¶½' => 'z', 'áº' => 'Z', 'áº‘' => 'z', 'áº’' => 'Z', 'áº“' => 'z', 'áº”' => 'Z', 'áº•' => 'z', 'â„¨' => 'Z', 'â±«' => 'Z', 'â±¬' => 'z',
        'ðŒ€' => 'a', 'ðŒ‰' => 'i', 'ðŒ' => 'o', 'ðŒ–' => 'u', '.' => '_', '=' => '_', '%' => '_', ';' => '_'
    }

    def get_features_paths
      return Dir['testes/cucumber/features/*.feature']
    end

    #@returns one array containing two arrays
    def map_all_scenarios_with_tags

      @current_number = 0
      all_tags = []
      scenarios_with_tags = []

      @arr_features = get_features_paths
      i =1

      @arr_features.each do |path|

        #puts "\n#{i} - Opening=#{path}"

        line_num = 0
        scenario_tags = []
        File.open(path).each do |line|
          line_num +=1

          # find if there are tags in this line
          match = line.scan /^(\s*@(?:\d|\w|-|_|\.)+(?:\s+@(?:\d|\w|-|_|\.)+)*\s*)$/i

          #puts match.inspect
          if !match.empty?
            # substituir caracteres especiais
            match.each do |m|
              m = m[0].gsub!(/\n|\r/, '');
            end
            all_tags << match[0][0].split(' ') #[0]

            #p "match: #{match[0][0].split(' ')}"
            scenario_tags << match[0][0].split(' ') #[0]
          end

          #match = line.match /^\s*Scenario:[^"]*$/i
          if (line.match /^\s*Scenario[ Outline]*:[^"]*$/i)
            str = line.match /^\s*Scenario:[^"]*$/i

            line = line.gsub(/\n/, '');
            line = line.gsub(/\r/, '');
            # [tag, [tag, tag], [tag]] -> ficar de uma dimensao
            scenario_tags.flatten!
            scenario_tags.compact!
            scenario_tags.uniq!
            scenarios_with_tags[@current_number] = [line, scenario_tags, "#{path}:#{line_num}"]
            line = "Scenario nr.#{@current_number}: #{line}\n"

            @current_number += 1
            scenario_tags = []
          end
        end

        i+=1
      end

      all_tags.flatten!
      all_tags.compact!
      all_tags.uniq!

      return scenarios_with_tags, all_tags

    end

    desc "Map Cucumber tags with scenarios"
    task :map_all_scenarios_with_tag do
      t1 = Time.now

      p map_all_scenarios_with_tags.inspect

      puts "Time elapsed #{calculate_time_elapsed(t1)}"


    end

    desc "list all duplicated scenarios"
    task :list_all_scenarios_duplicated do
      # Set Hash to 0 so it counts
      counter = Hash.new(0)
      places = Hash.new()

      # iterate over the list
      map_all_scenarios_with_tags[0].each { |x|
        counter[x[0]] += 1
        if places[x[0]]
          places[x[0]].push x[2]
        else
          places[x[0]] = [x[2]]
        end

      }

      nr_of_duplicates = 0

      # return the Hash
      counter.each do |scenario_name, times|
        if times > 1
          puts "#{scenario_name} x #{times}"
          puts "   in:"
          places[scenario_name].each do |place|
            puts "      #{place}"
            nr_of_duplicates += 1
          end
          puts "\n\n"
        end
      end

      if nr_of_duplicates == 0
        puts "\nNo duplicated scenarios found. Good Work!"
      else
        puts "#{nr_of_duplicates} duplicated scenarios found!"
      end

      # p places.inspect
      # p map_all_scenarios_with_tags.inspect
    end

    desc "List all scenarios that have a certain tag "
    task :list_all_scenarios_by_tag, :tag do |t, params|
      #p t
      params[:tag].gsub!('tag][', '')
      puts "Searching scenarios with tag: #{params[:tag]}"
      all_scen_w_tags = map_all_scenarios_with_tags
      counter = 0
      all_scen_w_tags[0].each do |swt|
        #p swt
        if swt[1].include?(params[:tag])
          puts "#{swt[0]} in #{swt[2]}"
          counter+=1
        end
      end
      puts "\nTotal: #{counter} scenarios"
    end

    desc "List all scenarios that doesn't have a certain tag"
    task :list_all_scenarios_without_tag, :tag do |t, params|
      #p t
      params[:tag].gsub!('tag][', '')
      puts "Searching scenarios with tag: #{params[:tag]}"
      all_scen_w_tags = map_all_scenarios_with_tags

      all_scen_w_tags[0].each do |swt|
        #p swt
        unless swt[1].include?(params[:tag])
          puts "#{swt[0]} in #{swt[2]}"
        end
      end
    end

    desc "List all scenarios that have a certain tag like "
    task :list_all_scenarios_by_tag_like, :tag do |t, params|
      #p t
      params[:tag].gsub!('tag][', '')
      puts "Searching scenarios with tag: #{params[:tag]}"
      all_scen_w_tags = map_all_scenarios_with_tags

      all_scen_w_tags[0].each do |swt|
        #p swt
        if swt[1].join(' ').include?(params[:tag])
          puts "#{swt[0]} in #{swt[2]}"
        end
      end

      #puts all_scen_w_tags[0][3][1].join(' ')

    end

    desc "List all scenarios that doesn't have a certain tag like "
    task :list_all_scenarios_without_tag_like, :tag do |t, params|

      #p t
      params[:tag].gsub!('tag][', '')
      puts "Searching scenarios without tag like: #{params[:tag]}"
      all_scen_w_tags = map_all_scenarios_with_tags

      count = 0
      all_scen_w_tags[0].each do |swt|
        #p swt
        unless swt[1].join(' ').include?(params[:tag])
          puts "#{swt[0]} in #{swt[2]}"
          count+=1
        end
      end

      puts "\n\nNumber of scenarios without tag like '#{params[:tag]}': #{count}"

      #puts all_scen_w_tags[0][3][1].join(' ')

    end

    desc 'find max id of scenarios'
    task :find_max_id_of_scenarios do
      require 'find'

      def get_features_paths
        return Dir['features/**/*.feature']
        #return Dir['features/ADR/QNT-3586_-_O_sistema_devera_ter_a_capacidade_de_gerar_CDRs.feature']
      end

      @current_number = 0
      @arr_features = []
      str_out = ""
      @max_num_geral = 0
      ids = []
      @arr_features = get_features_paths
      @arr_features.each do |path|
        @max_num_ficheiro = 0
        File.open(path).each do |line|
          match = line.match /^(\s*@(?:\d|\w|-|_)+(?:\s+@(?:\d|\w|-|_)+)*\s*)$/i
          if line.match /^(\s*@(?:\d|\w|-|_)+(?:\s+@(?:\d|\w|-|_)+)*\s*)$/i
            str = line.match /^(\s*@(?:\d|\w|-|_)+(?:\s+@(?:\d|\w|-|_)+)*\s*)$/i
            if str[0].match /@TEST_ID-\d*/
              #puts line
              tag = str[0].scan /@TEST_ID-(\d*)/
              #puts tag.inspect

              @max_num_ficheiro = tag[0][0].to_s.to_i
              @max_num_geral = @max_num_ficheiro if (@max_num_ficheiro > @max_num_geral)
              # puts "Already has tag"

              if ids.include? @max_num_ficheiro
                puts "Tag duplicada: @TEST_ID-#{@max_num_ficheiro}"
              else
                ids << @max_num_ficheiro
              end
            else
              #puts "Tag not found"
            end
          end
          str_out += line
        end
        #puts "Max num found=#{@max_num_ficheiro}"
        #puts "Path=#{path}"
      end
      puts "Final Max num found=#{@max_num_geral}"
    end

    #--------------------------------------------------------------------------------------------------------------------

    desc 'Add ids unicos aos scenarios'
    task :add_ids_unicos_aos_scenarios do
      p 'started'
      require 'find'

      def get_features_paths
        return Dir['features/**/*.feature']
        #return Dir['features/ADR/QNT-3586_-_O_sistema_devera_ter_a_capacidade_de_gerar_CDRs.feature']
      end

      def get_max_num
        str_out = ""
        max_num_geral = 0
        ids = []
        arr_features = get_features_paths
        arr_features.each do |path|
          max_num_ficheiro = 0
          File.open(path).each do |line|
            match = line.match /^(\s*@(?:\d|\w|-|_)+(?:\s+@(?:\d|\w|-|_)+)*\s*)$/i
            if line.match /^(\s*@(?:\d|\w|-|_)+(?:\s+@(?:\d|\w|-|_)+)*\s*)$/i
              str = line.match /^(\s*@(?:\d|\w|-|_)+(?:\s+@(?:\d|\w|-|_)+)*\s*)$/i
              if str[0].match /@TEST_ID_\d*/
                #puts line
                tag = str[0].scan /@TEST_ID_(\d*)/
                #puts tag.inspect

                max_num_ficheiro = tag[0][0].to_s.to_i
                max_num_geral = max_num_ficheiro if (max_num_ficheiro > max_num_geral)
                # puts "Already has tag"

                if ids.include? max_num_ficheiro
                  puts "Tag duplicada: @TEST_ID_#{max_num_ficheiro}"
                else
                  ids << max_num_ficheiro
                end
              else
                #puts "Tag not found"
              end
            end
            str_out += line
          end
          #puts "Max num found=#{@max_num_ficheiro}"
          #puts "Path=#{path}"
        end
        puts "Final Max num found=#{max_num_geral}"
        return max_num_geral
      end

      @current_number = get_max_num + 1
      @arr_features = get_features_paths
      str_out = ""
      tag = false
      i = 0
      @arr_features.each do |path|
        puts "\n#{i} - Opening=#{path}"
        str_out = ""
        str_block =""
        line_num = 0
        File.open(path).each do |line|
          #print "#{line_num += 1} #{line}"
          str_block += line
          #match = line.match /^\s*Scenario:[^"]*$/i
          if line.match /^\s*Scenario[ Outline]*:[^"]*$/i
            str = line.match /^\s*Scenario[ Outline]*:[^"]*$/i
            tag = true
            if str_block.match /@TEST_\w+-\d+/
              #puts "Already has tag... do nothing"
            else
              new_line = "@TEST_ID_#{@current_number}\n#{line.gsub(/\n/, "").gsub(/\r/, "")}\n"
              puts "Added tag"
              puts <<-LOG
              Substitued:
              -------------------------------------------------------
              #{line}
              -------------------------------------------------------

              for:
              -------------------------------------------------------
              #{new_line}
              -------------------------------------------------------
              LOG
              @current_number += 1
              str_block.gsub!(line, new_line)
            end
          end
          #puts line
          if tag
            str_out << str_block
            str_block = ""
            tag = false
          end
        end
        str_out << str_block
        f_out = File.new path, "w"
        f_out.write str_out
        f_out.close
        #puts str_out
        puts "Completed"
        i+=1
      end

    end

  end # end of namespace :cucumber_tags


  namespace :run do

    require 'cucumber'
    require 'cucumber/rake/task'

    desc 'Run tests with tags'
    task :with_tags, :tags do |_, args|
      Cucumber::Rake::Task.new :run do |task|
        tags = args.to_a.map { |tag| tag.include?('~') ? tag.gsub('~', '~@') : "@#{tag}" }
        task.bundler = false
        task.cucumber_opts = "--tags #{tags.join(',')}"
      end
      Rake::Task[:run].invoke
    end

    desc 'Run a complete feature'
    task :feature, :feature_name do |_, params|
      Cucumber::Rake::Task.new(:feature) do |task|
        ENV['FEATURE'] = Dir.glob(File.join('features', '**', "#{params[:feature_name]}.feature")).first
      end.runner.run
    end

    desc 'Set the environment to run tests in'
    task :in_amb, :amb do |_, params|
      File.open('hudsonBuild.properties', 'a') do |file|
        file.puts "run.environment=#{params[:amb]}"
      end
    end

  end #end namespace :run

end #end namespace :tests